from enum import Enum
import io
import logging
import os
import subprocess
from socket import gethostname
from threading import Thread
from typing import Sequence, NamedTuple, Optional, Text


#
# Logging
#

class AnsiCode(Enum):
    DEFAULT = '\x1b[0m'
    RED = '\x1b[31m'
    GREEN = '\x1b[32m'
    YELLOW = '\x1b[33m'
    CYAN = '\x1b[36m'


LOG_LEVEL_TO_COLOR = {
    logging.CRITICAL: AnsiCode.RED,
    logging.ERROR: AnsiCode.RED,
    logging.WARNING: AnsiCode.YELLOW,
    logging.INFO: AnsiCode.GREEN,
    logging.DEBUG: AnsiCode.CYAN
}


class AnsiLoggingStreamHandler(logging.StreamHandler):
    # Overriding from logging.Handler(Filtered)
    def format(self, record: logging.LogRecord) -> Text:
        level = record.levelno
        text = super().format(record)
        color = LOG_LEVEL_TO_COLOR[level].value
        return color + text + AnsiCode.DEFAULT.value


LOG_FORMAT = "%(levelname)-7s %(message)s"

logging.basicConfig(format=LOG_FORMAT,
                    handlers=[AnsiLoggingStreamHandler()])

log = logging.getLogger('provisioner')
log.setLevel(logging.DEBUG)


def pipe_to_logger(pipe, logger: logging.Logger, level: int):
    for line in io.TextIOWrapper(pipe):
        if (l := line.strip()):
            logger.log(level, l)


#
# Shell commands execution
#

def run(cmd: Sequence[str], stdin: Optional[Sequence[str]] = None):
    log.debug("Executing: {}".format(' '.join(cmd)))

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


#
# Network.
#

def ping(host):
    return run(['ping', '-c1', host])


#
# Preliminary steps.
#

def check_archiso():
    if gethostname() != 'archiso':
        raise Exception("This is supposed to run inside the Arch live image.")
    return True


def check_efivars():
    log.info("Checking EFI vars.")
    if not os.path.isdir('/sys/firmware/efi/efivars'):
        raise Exception("Could not find EFI vars.")
    log.info("EFI vars OK.")
    return True


def check_network():
    log.info("Checking network.")
    ping('archlinux.org')
    log.info("Network OK.")
    return True


def enable_ntp():
    log.info("Enabling NTP.")
    run(['timedatectl', 'set-ntp', 'true'])
    log.info("NTP OK.")
    return True


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


PartitionSize = Optional[str]


class Partition(NamedTuple):
    type: PartitionType
    filesystem: Filesystem
    size: PartitionSize
    label: str


def dev_path(dev, number):
    return "".join((dev, str(number)))


def sgdisk_zap(dev):
    log.info("Erasing MBR and GPT data structures from {}.".format(dev))
    run(['sgdisk', '--zap-all', dev])
    log.info("Erasing OK.")
    return True


def sgdisk_new_table(dev):
    log.info("Creating new GPT table on {}.".format(dev))
    run(['sgdisk', '--mbrtogpt', dev])
    log.info("EFI table creation OK.")
    return True


def sgdisk_new(dev, number, partition: Partition):
    run(['sgdisk',
         ('--new={}:0:+{}'.format(number, partition.size)
          if partition.size is not None
          else '--largest-new={}'.format(number)),
         '--typecode={}:{}'.format(number, partition.type.value),
         '--change-name={}:{}'.format(number, partition.label),
         dev])


def luks_format(path, cipher, key_size, passphrase):
    run(['cryptsetup', 'luksFormat',
         '--batch-mode',
         '--align-payload=8192',
         '--cipher={}'.format(cipher),
         '--key-size={}'.format(key_size),
         '--key-file=-',
         path],
        stdin=[passphrase])


def make_filesystem(path, partition: Partition):
    run([*partition.filesystem.value,
         '-n', partition.label,
         path])


def make_partitions(dev: str, partitions: Sequence[Partition]):
    for number, partition in zip(range(1, len(partitions) + 1), partitions):
        sgdisk_new(dev, number, partition)

        if (partition.type == PartitionType.LUKS
            and partition.filesystem != Filesystem.SWAP):
            luks_format(dev_path(dev, number),
                        'aes-xts-plain64', 256,
                        'changeme')


#
# Main
#


PARTITIONS: Sequence[Partition] = (
    Partition(PartitionType.EFI, Filesystem.FAT32, '512M', 'efi'),
    Partition(PartitionType.LUKS, Filesystem.SWAP, '4G', 'swap'),
    Partition(PartitionType.LUKS, Filesystem.EXT4, None, 'system')
)


if __name__ == '__main__':
    check_archiso()
    check_efivars()
    check_network()
    enable_ntp()
    sgdisk_zap('/dev/sda')
    sgdisk_new_table('/dev/sda')
    make_partitions('/dev/sda', PARTITIONS)
