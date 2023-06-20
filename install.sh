set -eu

DISK="/dev/sda"

PART_EFI="${DISK}1"
PART_SYS="${DISK}2"

LUKS_SYS_NAME="system"
LUKS_SYS_PATH="/dev/mapper/${LUKS_SYS_NAME}"

MOUNT_EFI="/mnt/efi"

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
btrfs subvolume create /mnt/boot
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/state
btrfs subvolume create /mnt/log
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/home/tancredi
btrfs subvolume snapshot -r /mnt/root /mnt/root-empty
umount /mnt

mount -o subvol=root,compress=zstd,noatime "$LUKS_SYS_PATH" /mnt

mkdir /mnt/boot
mount -o subvol=boot,compress=zstd,noatime "$LUKS_SYS_PATH" /mnt/boot

mkdir -p "$MOUNT_EFI"
mount "$PART_EFI" "$MOUNT_EFI"

mkdir -p /mnt/nix
mount -o subvol=nix,compress=zstd,noatime "$LUKS_SYS_PATH" /mnt/nix

mkdir -p /mnt/var/state
mount -o subvol=state,compress=zstd,noatime "$LUKS_SYS_PATH" /mnt/var/state

mkdir -p /mnt/var/log
mount -o subvol=log,compress=zstd,noatime "$LUKS_SYS_PATH" /mnt/var/log

mkdir -p /mnt/home/tancredi
mount -o subvol=home,compress=zstd,noatime "$LUKS_SYS_PATH" /mnt/home/tancredi

dd if=/dev/urandom of=/tmp/keyfile.bin bs=1024 count=4
cryptsetup luksAddKey "PART_SYS" /tmp/keyfile.bin
echo /tmp/keyfile.bin                         \
    | cpio -o -H newc -R +0:+0 --reproducible \
    | gzip -9 > /mnt/boot/initrd.keys.gz

nixos-generate-config      \
    --root /mnt            \
    --show-hardware-config \
    > configuration/hardware.nix

# nixos-install --verbose --no-root-password --flake .#bahnhof
