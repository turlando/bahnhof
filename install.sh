set -eu

DISK="/dev/sda"
PART_EFI="${DISK}1"
PART_SYS="${DISK}2"
LUKS_SYS_NAME="system"
LUKS_SYS_PATH="/dev/mapper/${LUKS_SYS_NAME}"

sgdisk --zap-all "$DISK"

parted --script "$DISK"                 \
    mklabel gpt                         \
    mkpart "EFI"    fat32 1MiB   512MiB \
    mkpart "System"       512MiB 100%   \
    set 1 esp on

cryptsetup --verify-passphrase -v \
    luksFormat --type luks1 -c aes-xts-plain64 -s 256 -h sha512 \
    "$PART_SYS"
cryptsetup --allow-discards luksOpen "$PART_SYS" "$LUKS_SYS_NAME"

mkfs.vfat -F 32 -n "EFI" "$PART_EFI"
mkfs.btrfs -L "System" "$LUKS_SYS_PATH"

mount -t btrfs "$LUKS_SYS_PATH" /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/state
btrfs subvolume create /mnt/log
btrfs subvolume create /mnt/home
btrfs subvolume snapshot -r /mnt/root /mnt/root-empty
umount /mnt

mount -o subvol=root,compress=zstd,noatime "$LUKS_SYS_PATH" /mnt

mkdir /mnt/home
mount -o subvol=home,compress=zstd,noatime "$LUKS_SYS_PATH" /mnt/home

mkdir /mnt/nix
mount -o subvol=nix,compress=zstd,noatime "$LUKS_SYS_PATH" /mnt/nix

mkdir -p /mnt/var/state
mount -o subvol=state,compress=zstd,noatime "$LUKS_SYS_PATH" /mnt/var/state

mkdir -p /mnt/var/log
mount -o subvol=log,compress=zstd,noatime "$LUKS_SYS_PATH" /mnt/var/log

mkdir -p /mnt/boot
mount "$PART_EFI" /mnt/boot

nixos-generate-config      \
    --root /mnt            \
    --no-filesystems       \
    --show-hardware-config \
    > configuration/hardware.nix

nixos-install --verbose --no-root-password --flake .#bahnhof
