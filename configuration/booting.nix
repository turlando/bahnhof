{ lib, ... }:

{
  boot = {
    supportedFilesystems = [ "btrfs" ];

    loader = {
      efi = {
        efiSysMountPoint = "/boot/efi";
      };

      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        efiInstallAsRemovable = true;
        enableCryptodisk = true;
      };
    };

    initrd = {
      luks.devices = {
        "system" = {
          device = "/dev/sda2";
          allowDiscards = true;
        };
      };
    };
  };
}
