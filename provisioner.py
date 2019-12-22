import io
import logging
import os
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
# Network.
#

def ping(host):
    return run(['ping', '-c1', host])


#
# Disk.
#

class PartitionType(Enum):
    EFI = 'EF00'
    SWAP = '8200'
    LUKS = '8309'


class Filesystem(Enum):
    SWAP = ['mkswap']
    FAT32 = ['mkfs.vfat', '-F32']
    EXT4 = ['mkfs.ext4']


FilesystemToMkfsLabelSwitch = Dict[Filesystem, Text]


MKFS_LABEL_SWITCH: FilesystemToMkfsLabelSwitch = {
    Filesystem.SWAP: '-L',
    Filesystem.FAT32: '-n',
    Filesystem.EXT4: '-L'
}


@dataclass
class Partition:
    type: PartitionType
    filesystem: Filesystem
    size: Optional[Text]
    label: Text
    mount_path: Optional[Text] = None
    luks_cipher: Optional[Text] = None
    luks_key_size: Optional[int] = None
    luks_passphrase: Optional[Text] = None


Partitions = Sequence[Partition]


def dev_path(dev, number):
    return "".join((dev, str(number)))


def dev_mapper_path(name):
    return "/dev/mapper/{}".format(name)


def sgdisk_zap(dev):
    return run(['sgdisk', '--zap-all', dev])


def sgdisk_new_table(dev):
    return run(['sgdisk', '--mbrtogpt', dev])


def sgdisk_new(dev, number, partition: Partition):
    return run(['sgdisk',
                ('--new={}:0:+{}'.format(number, partition.size)
                 if partition.size is not None
                 else '--largest-new={}'.format(number)),
                '--typecode={}:{}'.format(number, partition.type.value),
                '--change-name={}:{}'.format(number, partition.label),
                dev])


def luks_format(path, cipher, key_size, passphrase):
    return run(['cryptsetup', 'luksFormat',
                '--batch-mode',
                '--align-payload=8192',
                '--cipher={}'.format(cipher),
                '--key-size={}'.format(key_size),
                '--key-file=-',
                path],
               stdin=[passphrase])


def luks_open(path, name, passphrase):
    return run(['cryptsetup', 'luksOpen', path, name],
               stdin=[passphrase])


def luks_close(name):
    return run(['cryptsetup', 'luksClose', name])


def make_filesystem(path, filesystem: Filesystem, label: Text):
    return run([*filesystem.value,
                MKFS_LABEL_SWITCH[filesystem], label,
                path])


def make_partitions(dev: str, partitions: Partitions):
    for number, partition in zip(range(1, len(partitions) + 1), partitions):
        sgdisk_new(dev, number, partition)

        if partition.type == PartitionType.LUKS:
            luks_format(dev_path(dev, number),
                        partition.luks_cipher, partition.luks_key_size,
                        partition.luks_passphrase)
            luks_open(dev_path(dev, number), partition.label,
                      partition.luks_passphrase)
            make_filesystem(dev_mapper_path(partition.label),
                            partition.filesystem, partition.label)
            luks_close(partition.label)
        else:
            make_filesystem(dev_path(dev, number),
                            partition.filesystem,
                            partition.label)

    return True


def mount_partitions(base_path, dev, partitions: Partitions):
    # Generate tuples of (partition_number, partition).
    # Filter out partitions that are not required to be mounted
    # (excluding swap devices).
    # FIXME: Mount order is given by the len of the mount_path.
    # Find a less lazy solution.
    partitions_ = sorted([(number, partition) for number, partition
                          in zip(range(1, len(partitions) + 1), partitions)
                          if (partition.mount_path is not None
                              or partition.filesystem == Filesystem.SWAP)],
                         key=lambda x: (len(x[1].mount_path)
                                        if x[1].mount_path is not None
                                        else 0))

    for number, partition in partitions_:
        if partition.type == PartitionType.LUKS:
            luks_open(dev_path(dev, number), partition.label,
                      partition.luks_passphrase)

        partition_path = (dev_mapper_path(partition.label)
                          if partition.type == PartitionType.LUKS
                          else dev_path(dev, number))

        if partition.filesystem == Filesystem.SWAP:
            run(['swapon', partition_path])
        else:
            mount_path = base_path + partition.mount_path
            os.makedirs(mount_path, exist_ok=True)
            run(['mount', partition_path, mount_path])

    return True


def umount_partitions(base_path, dev, partitions: Partitions):
    partitions_ = sorted([(number, partition) for number, partition
                          in zip(range(1, len(partitions) + 1), partitions)
                          if (partition.mount_path is not None
                              or partition.filesystem == Filesystem.SWAP)],
                         key=lambda x: (len(x[1].mount_path)
                                        if x[1].mount_path is not None
                                        else 0),
                         reverse=True)

    for number, partition in partitions_:
        partition_path = (dev_mapper_path(partition.label)
                          if partition.type == PartitionType.LUKS
                          else dev_path(dev, number))

        if partition.filesystem == Filesystem.SWAP:
            run(['swapoff', partition_path])
        else:
            run(['umount', partition_path])

        if partition.type == PartitionType.LUKS:
            luks_close(partition.label)

    return True


def genfstab(base_mount_path):
    return capture_run(['genfstab', '-U', base_mount_path])


def generate_fstab(base_mount_path):
    os.makedirs(base_mount_path + '/etc', exist_ok=True)
    with open(base_mount_path + '/etc/fstab', mode='w') as f:
        f.write(genfstab(base_mount_path))
    return True


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
LUKS_CIPHER = 'aes-xts-plain64'
LUKS_KEY_SIZE = 256
LUKS_PASSPHRASE = 'changeme'
BASE_MOUNT_PATH = '/mnt'

PARTITIONS: Partitions = (
    Partition(PartitionType.EFI, Filesystem.FAT32, '512M', 'efi', '/boot'),
    Partition(PartitionType.LUKS, Filesystem.SWAP, '4G', 'swap',
              luks_cipher=LUKS_CIPHER, luks_key_size=LUKS_KEY_SIZE,
              luks_passphrase=LUKS_PASSPHRASE),
    Partition(PartitionType.LUKS, Filesystem.EXT4, None, 'system', '/',
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
              lambda: make_partitions(DISK_PATH, PARTITIONS)),
    Operation("Mount filesystems.",
              lambda: mount_partitions(BASE_MOUNT_PATH, DISK_PATH, PARTITIONS)),
    Operation("Generate fstab.",
              lambda: generate_fstab(BASE_MOUNT_PATH)),
    Operation("Umount filesystems.",
              lambda: umount_partitions(BASE_MOUNT_PATH, DISK_PATH, PARTITIONS))
)


if __name__ == '__main__':
    execute_operations(OPERATIONS)
