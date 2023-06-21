set -eu

################################################################################

DISK="/dev/sda"

PART_EFI="${DISK}1"
PART_SYS="${DISK}2"

LABEL_EFI="EFI"
LABEL_SYS="System"

LUKS_SYS_NAME="system"
LUKS_SYS_PATH="/dev/mapper/${LUKS_SYS_NAME}"

MOUNT_ROOT="/mnt"
MOUNT_EFI="${MOUNT_ROOT}/efi"

POOL_SYS="system"

# Approximately 80% of 472GiB which is the available space
QUOTA_SYS="380G"

SWAP_SIZE="1G"

################################################################################

sgdisk --zap-all "$DISK"

parted --script "$DISK"                     \
    mklabel gpt                             \
    mkpart "$LABEL_EFI" fat32 1MiB   512MiB \
    mkpart "$LABEL_SYS"       512MiB 100%   \
    set 1 esp on

################################################################################

mkfs.vfat -F 32 -n "$LABEL_EFI" "$PART_EFI"

################################################################################

# GRUB only supports LUKS 1. That's what we have to deal with.

# This will ask for the encryption password twice.
cryptsetup --verify-passphrase -v \
    luksFormat --type luks1 -c aes-xts-plain64 -s 256 -h sha512 \
    "$PART_SYS"

# This will ask for the encryption password again.
cryptsetup --allow-discards luksOpen "$PART_SYS" "$LUKS_SYS_NAME"

################################################################################

zpool create                                        \
      -m none                                       \
      -o ashift=12                                  \
      -o compatibility=grub2                        \
      -o altroot=/mnt                               \
#      -O quota="$QUOTA_SYS"                         \
      -O canmount=off                               \
      -O checksum=fletcher4                         \
      -O compression=lz4                            \
      -O xattr=sa                                   \
      -O normalization=formD                        \
      -O atime=off                                  \
      "$POOL_SYS"                                   \
      "$LUKS_SYS_PATH"

zfs create               \
    -o mountpoint=legacy \
    -o acltype=posixacl  \
    -o compression=zstd  \
    "${POOL_SYS}/root"

zfs snapshot                 \
    "${POOL_SYS}/root@empty"

zfs create               \
    -o mountpoint=legacy \
    -o acltype=posixacl  \
    -o compression=lz4   \
    "${POOL_SYS}/boot"

zfs create               \
    -o mountpoint=legacy \
    -o compression=zstd  \
    "${POOL_SYS}/nix"

zfs create               \
    -o acltype=posixacl  \
    -o mountpoint=legacy \
    -o compression=zstd  \
    "${POOL_SYS}/log"

zfs create               \
    -o acltype=posixacl  \
    -o mountpoint=legacy \
    -o compression=zstd  \
    "${POOL_SYS}/state"

zfs create                      \
    -o acltype=posixacl         \
    -o mountpoint=legacy        \
    -o compression=zstd         \
    "${POOL_SYS}/tancredi"

zfs create                         \
    -b $(getconf PAGESIZE)         \
    -V "$SWAP_SIZE"                \
    -o compression=zstd            \
    -o logbias=throughput          \
    -o sync=always                 \
    -o primarycache=metadata       \
    -o secondarycache=none         \
    -o com.sun:auto-snapshot=false \
    "${POOL_SYS}/swap"

################################################################################

mkdir -p "$MOUNT_ROOT"
mount -t zfs "${POOL_SYS}/root" "$MOUNT_ROOT"

mount "$PART_EFI" "$MOUNT_EFI"

mkdir -p "${MOUNT_ROOT}/boot"
mount -t zfs "${POOL_SYS}/boot" "${MOUNT_ROOT}/boot"

mkdir -p "${MOUNT_ROOT}/nix"
mount -t zfs "${POOL_SYS}/nix" "${MOUNT_ROOT}/nix"

mkdir -p "${MOUNT_ROOT}/var/log"
mount -t zfs "${POOL_SYS}/log" "${MOUNT_ROOT}/var/log"

mkdir -p "${MOUNT_ROOT}/var/state"
mount -t zfs "${POOL_SYS}/state" "${MOUNT_ROOT}/var/state"

mkdir -p "${MOUNT_ROOT}/home/tancredi"
mount -t zfs "${POOL_SYS}/tancredi" "${MOUNT_ROOT}/home/tancredi"

mkswap -f "/dev/zvol/${POOL_SYS}/swap"
swapon "/dev/zvol/${POOL_SYS}/swap"

################################################################################

nixos-generate-config      \
    --root /mnt            \
    --show-hardware-config \
    > configuration/hardware.nix

# nixos-install --verbose --no-root-password --flake .#bahnhof
