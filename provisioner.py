import io
import logging
import os
import shutil
import subprocess
from dataclasses import dataclass
from enum import Enum
from socket import gethostname
from threading import Thread
from typing import Callable, Dict, Optional, Sequence, Text


#
# Logging helpers
#

class AnsiCode(Enum):
    DEFAULT = '\x1b[0m'
    RED = '\x1b[31m'
    GREEN = '\x1b[32m'
    YELLOW = '\x1b[33m'
    CYAN = '\x1b[36m'


LogLevelToAnsiCode = Dict[int, AnsiCode]


class AnsiLoggingStreamHandler(logging.StreamHandler):
    # Overriding from logging.Handler(Filtered)
    def format(self, record: logging.LogRecord) -> Text:
        level = record.levelno
        text = super().format(record)
        color = self.mapping[level].value
        return color + text + AnsiCode.DEFAULT.value

    # Overriding from logging.StreamHandler(Handler)
    def __init__(self, mapping: LogLevelToAnsiCode):
        self.mapping = mapping
        super().__init__(stream=None)


def pipe_to_logger(pipe, logger: logging.Logger, level: int):
    for line in io.TextIOWrapper(pipe):
        if (l := line.strip()):
            logger.log(level, l)


#
# Logging setup
#

LOG_FORMAT = "%(levelname).1s: %(message)s"

LOG_LEVEL_COLOR: LogLevelToAnsiCode = {
    logging.CRITICAL: AnsiCode.RED,
    logging.ERROR: AnsiCode.RED,
    logging.WARNING: AnsiCode.YELLOW,
    logging.INFO: AnsiCode.GREEN,
    logging.DEBUG: AnsiCode.CYAN
}

logging.basicConfig(format=LOG_FORMAT,
                    handlers=[AnsiLoggingStreamHandler(LOG_LEVEL_COLOR)])

log = logging.getLogger('provisioner')
log.setLevel(logging.DEBUG)


#
# Shell commands execution
#

def run(cmd: Sequence[str], stdin: Optional[Sequence[str]] = None):
    log.debug("Running: {}".format(' '.join(cmd)))

    p = subprocess.Popen(cmd,
                         stdout=subprocess.PIPE,
                         stderr=subprocess.PIPE,
                         stdin=subprocess.PIPE)

    outt = Thread(target=pipe_to_logger, args=[p.stdout, log, logging.DEBUG])
    errt = Thread(target=pipe_to_logger, args=[p.stderr, log, logging.WARNING])
    outt.start()
    errt.start()

    if stdin is not None:
        log.debug("Input: {}".format(stdin))
        with p.stdin as f:
            f.write('\n'.join(stdin).encode('ascii'))

    p.wait()
    outt.join()
    errt.join()

    if p.returncode != 0:
        raise Exception("Error: {}".format(p.returncode))
    return True


def capture_run(cmd):
    log.debug("Running: {}".format(' '.join(cmd)))
    p = subprocess.run(cmd, capture_output=True)
    stdout = p.stdout.decode()
    for line in stdout.splitlines():
        log.debug(line)
    return stdout


#
# Network
#

def ping(host):
    return run(['ping', '-c1', host])


def set_hostname(base_mount_path, hostname):
    with open(base_mount_path + '/etc/hostname', mode='w') as f:
        f.write(hostname)
    return True


#
# Partition description
#

class PartitionType(Enum):
    EFI = 'EF00'
    SWAP = '8200'
    LUKS = '8309'


class Filesystem(Enum):
    SWAP = ['mkswap']
    FAT32 = ['mkfs.vfat', '-F32']
    EXT4 = ['mkfs.ext4']


@dataclass
class UnparsedPartition:
    type: PartitionType
    filesystem: Filesystem
    size: Optional[Text]
    label: Text
    mount_path: Optional[Text] = None
    luks_cipher: Optional[Text] = None
    luks_key_size: Optional[int] = None
    luks_passphrase: Optional[Text] = None


@dataclass
class Partition:
    dev_path: Text
    number: int
    path: Text
    type: PartitionType
    filesystem: Filesystem
    label: Text
    size: Optional[Text]
    mount_path: Optional[Text] = None
    luks_path: Optional[Text] = None
    luks_cipher: Optional[Text] = None
    luks_key_size: Optional[int] = None
    luks_passphrase: Optional[Text] = None


Partitions = Sequence[Partition]


def make_partition_path(dev, number):
    return "".join((dev, str(number)))


def make_partition_mapper_path(name):
    return "/dev/mapper/{}".format(name)


def parse_partitions(dev: Text, *unparseds: UnparsedPartition) -> Partitions:
    def _parse_partitions():
        for number, partition in zip(range(1, len(unparseds) + 1),
                                     unparseds):
            yield Partition(
                dev_path=dev,
                number=number,
                path=make_partition_path(dev, number),
                type=partition.type,
                filesystem=partition.filesystem,
                label=partition.label,
                size=partition.size,
                mount_path=partition.mount_path,
                luks_path=(make_partition_mapper_path(partition.label)
                           if partition.type == PartitionType.LUKS
                           else None),
                luks_cipher=partition.luks_cipher,
                luks_key_size=partition.luks_key_size,
                luks_passphrase=partition.luks_passphrase
            )

    return tuple(_parse_partitions())


def get_root_partition(partitions: Partitions) -> Optional[Partition]:
    for p in partitions:
        if p.mount_path == '/':
            return p
    return None


def get_first_swap_partition(partitions: Partitions) -> Optional[Partition]:
    return [p for p in partitions
            if p.filesystem == Filesystem.SWAP][0]


#
# sgdisk helpers
#

def sgdisk_zap(dev):
    return run(['sgdisk', '--zap-all', dev])


def sgdisk_new_table(dev):
    return run(['sgdisk', '--mbrtogpt', dev])


def sgdisk_new(dev: Text, number: int, partition_type: PartitionType,
               label: Text, size: Text = None):
    return run(['sgdisk',
                ('--new={}:0:+{}'.format(number, size)
                 if size is not None
                 else '--largest-new={}'.format(number)),
                '--typecode={}:{}'.format(number, partition_type.value),
                '--change-name={}:{}'.format(number, label),
                dev])


#
# LUKS helpers
#

def luks_format(path: Text, cipher: Text, key_size: int, passphrase: Text):
    return run(['cryptsetup', 'luksFormat',
                '--batch-mode',
                '--align-payload=8192',
                '--cipher={}'.format(cipher),
                '--key-size={}'.format(key_size),
                '--key-file=-',
                path],
               stdin=[passphrase])


def luks_open(path: Text, name: Text, passphrase: Text):
    return run(['cryptsetup', 'luksOpen', path, name],
               stdin=[passphrase])


def luks_close(name: Text):
    return run(['cryptsetup', 'luksClose', name])


#
# mkfs helpers
#


FilesystemToMkfsLabelSwitch = Dict[Filesystem, Text]


MKFS_LABEL_SWITCH: FilesystemToMkfsLabelSwitch = {
    Filesystem.SWAP: '-L',
    Filesystem.FAT32: '-n',
    Filesystem.EXT4: '-L'
}


def make_filesystem(path: Text, filesystem: Filesystem, label: Text):
    return run([*filesystem.value,
                MKFS_LABEL_SWITCH[filesystem], label,
                path])


#
# Partitions actualization
#

def make_partitions(partitions: Partitions):
    for partition in partitions:
        sgdisk_new(partition.dev_path, partition.number,
                   partition.type, partition.label, partition.size)

        if partition.type == PartitionType.LUKS:
            luks_format(partition.path,
                        partition.luks_cipher, partition.luks_key_size,
                        partition.luks_passphrase)
            luks_open(partition.path, partition.label,
                      partition.luks_passphrase)
            make_filesystem(partition.luks_path,
                            partition.filesystem, partition.label)
            luks_close(partition.label)
        else:
            make_filesystem(partition.path,
                            partition.filesystem,
                            partition.label)

    return True


def mount_partitions(base_path, partitions: Partitions):
    # Filter out partitions that are not required to be mounted
    # (excluding swap devices).
    # FIXME: Mount order is given by the len of the mount_path.
    # Find a less lazy solution.
    partitions_ = sorted([partition for partition in partitions
                          if (partition.mount_path is not None
                              or partition.filesystem == Filesystem.SWAP)],
                         key=lambda p: (len(p.mount_path)
                                        if p.mount_path is not None
                                        else 0))

    for partition in partitions_:
        if partition.type == PartitionType.LUKS:
            luks_open(partition.path, partition.label,
                      partition.luks_passphrase)

        partition_path = partition.luks_path or partition.path

        if partition.filesystem == Filesystem.SWAP:
            run(['swapon', partition_path])
        else:
            mount_path = base_path + partition.mount_path
            os.makedirs(mount_path, exist_ok=True)
            run(['mount', partition_path, mount_path])

    return True


def umount_partitions(base_path, partitions: Partitions):
    partitions_ = sorted([partition for partition in partitions
                          if (partition.mount_path is not None
                              or partition.filesystem == Filesystem.SWAP)],
                         key=lambda x: (len(x.mount_path)
                                        if x.mount_path is not None
                                        else 0),
                         reverse=True)

    for partition in partitions_:
        partition_path = partition.luks_path or partition.path

        if partition.filesystem == Filesystem.SWAP:
            run(['swapoff', partition_path])
        else:
            run(['umount', partition_path])

        if partition.type == PartitionType.LUKS:
            luks_close(partition.label)

    return True


#
# genfstab helpers
#

def genfstab(base_mount_path):
    return capture_run(['genfstab', '-U', base_mount_path])


def generate_fstab(base_mount_path):
    os.makedirs(base_mount_path + '/etc', exist_ok=True)
    with open(base_mount_path + '/etc/fstab', mode='w') as f:
        f.write(genfstab(base_mount_path))
    return True


#
# crypttab helpers
#

def crypttab_swap_entries(partitions: Partitions, cipher, key_size):
    swap_partitions = [partition for partition in partitions
                       if partition.type == PartitionType.SWAP]

    return ["swap {} /dev/urandom swap,cipher={},size={},discard\n"
            .format(partition.path, cipher, key_size)
            for partition in swap_partitions]


def write_crypttab_swap_entries(base_mount_path, partitions, cipher, key_size):
    with open(base_mount_path + '/etc/crypttab', mode='a+') as f:
        f.write(''.join(crypttab_swap_entries(partitions, cipher, key_size)))
    return True


#
# EFISTUB
#

# TODO: This will not work with an unencrypted install.
def startup_nsh(root_device, root_label, root_device_mapper, swap_device):
    return (' '
            .join(["vmlinuz-linux", "rw",
                   "initrd=initramfs-linux.img",
                   "cryptdevice={root_device}:{root_label}:allow-discards",
                   "root={root_device_mapper}",
                   "resume={swap_device}"])
            .format(root_device=root_device,
                    root_label=root_label,
                    root_device_mapper=root_device_mapper,
                    swap_device=swap_device))


def generate_startup_nsh(base_mount_path, partitions):
    file = base_mount_path + '/boot/startup.nsh'
    root_partition = get_root_partition(partitions)
    swap_partition = get_first_swap_partition(partitions)

    with open(file, mode='w') as f:
        f.write(startup_nsh(root_partition.path,
                            root_partition.label,
                            root_partition.luks_path,
                            swap_partition.luks_path or swap_partition.path))

    return True


#
# initramfs
#


def create_hook(base_mount_path, name, description, script):
    hook_file = base_mount_path + '/etc/initcpio/hooks/' + name
    install_file = base_mount_path + '/etc/initcpio/install/' + name

    with open(hook_file, mode='w') as f:
        f.write("run_hook() {\n")
        for l in script:
            f.write(l + "\n")
        f.write("}")

    with open(install_file, mode='w') as f:
        f.write("build() {\n")
        f.write("add_runscript\n")
        f.write("}\n\n")
        f.write("help(){\n")
        f.write("cat<<HEREDOC\n")
        f.write("\n".join(description) + "\n")
        f.write("HEREDOC\n")
        f.write("}")

    return True


def create_cryptswap_hook(base_mount_path, partitions: Partitions):
    partitions_ = [p for p in partitions
                   if p.type == PartitionType.LUKS
                   and p.filesystem == Filesystem.SWAP]

    create_hook(base_mount_path, 'cryptswap',
                "Open encrypted swap partitions.",
                ["cryptsetup open {path} {label}".format(path=partition.path,
                                                         label=partition.label)
                 for partition in partitions_])

    return True


def mkinitcpio_conf(modules: Optional[Sequence[Text]] = None,
                    binaries: Optional[Sequence[Text]] = None,
                    files: Optional[Sequence[Text]] = None,
                    hooks: Optional[Sequence[Text]] = None,
                    compression: Optional[Text] = 'gzip'):
    return ('MODULES="{}"\n'
            'BINARIES="{}"\n'
            'FILES="{}"\n'
            'HOOKS="{}"\n'
            'COMPRESSION="{}"').format(' '.join(modules) if modules else '',
                                       ' '.join(binaries) if binaries else '',
                                       ' '.join(files) if files else '',
                                       ' '.join(hooks) if hooks else '',
                                       compression)


def generate_mkinitcpio_conf(base_mount_path, make_backup=True, **kwargs):
    file = base_mount_path + '/etc/mkinitcpio.conf'
    back_file = file + '.bak'

    if make_backup:
        shutil.copy2(file, back_file)

    with open(file, mode='w') as f:
        f.write(mkinitcpio_conf(**kwargs))

    return True


#
# Users and groups
#

def passwd(username, password, chroot=None):
        return run([*(['arch-chroot', chroot] if chroot else []),
                    'chpasswd'],
                   stdin=["{}:{}".format(username, password)])


def adduser(username, password, chroot=None):
    return run([*(['arch-chroot', chroot] if chroot else []),
                'useradd',
                '-m',
                '-N', '-g', 'users',
                '-G', 'wheel,audio',
                '-p', password,
                username])


#
# Operation
#

DEFAULT_SUCCESS_TEXT = "Success!"
DEFAULT_FAILURE_TEXT = "Failed!"


@dataclass
class Operation:
    description: Text
    fn: Callable[[], bool]
    success_text: Optional[Text] = None
    failure_text: Optional[Text] = None


Operations = Sequence[Operation]


def execute_operations(operations: Operations):
    for operation in operations:
        log.info(operation.description)

        success_text_ = operation.success_text or DEFAULT_SUCCESS_TEXT
        failure_text_ = operation.failure_text or DEFAULT_FAILURE_TEXT

        if operation.fn():
            log.info(success_text_)
        else:
            log.error(failure_text_)


#
# Main
#

DISK_PATH = '/dev/sda'
BASE_MOUNT_PATH = '/mnt'

LUKS_CIPHER = 'aes-xts-plain64'
LUKS_KEY_SIZE = 256
LUKS_PASSPHRASE = 'changeme'

HOSTNAME = 'bahnhof'
ROOT_PASSWORD = 'changeme'

USERNAME = 'tancredi'
PASSWORD = 'changeme'


PARTITIONS: Partitions = parse_partitions(
    DISK_PATH,
    UnparsedPartition(PartitionType.EFI, Filesystem.FAT32, '512M',
                      'efi', '/boot'),
    UnparsedPartition(PartitionType.SWAP, Filesystem.SWAP, '1G', 'swap'),
    UnparsedPartition(PartitionType.LUKS, Filesystem.EXT4, None,
                      'system', '/',
                      luks_cipher=LUKS_CIPHER, luks_key_size=LUKS_KEY_SIZE,
                      luks_passphrase=LUKS_PASSPHRASE)
)

OPERATIONS: Operations = (
    Operation("Check if running inside Arch live image.",
              lambda: gethostname() == 'archiso',
              failure_text="This is supposed to run inside the Arch live image."),
    Operation("Check EFI variables.",
              lambda: os.path.isdir('/sys/firmware/efi/efivars'),
              failure_text="Your system doesn't seem to run in EFI mode."),
    Operation("Check network availability.",
              lambda: ping('archlinux.org')),
    Operation("Enable NTP.",
              lambda: run(['timedatectl', 'set-ntp', 'true'])),
    Operation("Erasing MBR and GPT data structures from {}.".format(DISK_PATH),
              lambda: sgdisk_zap(DISK_PATH)),
    Operation("Creating new GPT table on {}.".format(DISK_PATH),
              lambda: sgdisk_new_table(DISK_PATH)),
    Operation("Create partitions.",
              lambda: make_partitions(PARTITIONS)),
    Operation("Mount filesystems.",
              lambda: mount_partitions(BASE_MOUNT_PATH, PARTITIONS)),
    Operation("Install base packages.",
              lambda: run(['pacstrap', BASE_MOUNT_PATH, 'base', 'linux'])),
    Operation("Generate fstab.",
              lambda: generate_fstab(BASE_MOUNT_PATH)),
    Operation("Generate crypttab.",
              lambda: write_crypttab_swap_entries(BASE_MOUNT_PATH, PARTITIONS,
                                                  LUKS_CIPHER, LUKS_KEY_SIZE)),
    Operation("Set hostname.",
              lambda: set_hostname(BASE_MOUNT_PATH, HOSTNAME)),
    Operation("Setup mkinitcpio.",
              lambda: generate_mkinitcpio_conf(
                  BASE_MOUNT_PATH,
                  hooks=['base', 'udev', 'autodetect', 'modconf',
                         'block', 'encrypt', 'filesystems', 'keyboard','fsck'])),
    Operation("Generate initramfs.",
              lambda: run(['arch-chroot', BASE_MOUNT_PATH, 'mkinitcpio', '-P'])),
    Operation("Setup EFISTUB.",
              lambda: generate_startup_nsh(BASE_MOUNT_PATH, PARTITIONS)),
    Operation("Set root password.",
              lambda: passwd('root', ROOT_PASSWORD, chroot=BASE_MOUNT_PATH)),
    Operation("Setup user.",
              lambda: adduser(USERNAME, PASSWORD, chroot=BASE_MOUNT_PATH)),
    Operation("Umount filesystems.",
              lambda: umount_partitions(BASE_MOUNT_PATH, PARTITIONS))
)


if __name__ == '__main__':
    execute_operations(OPERATIONS)
