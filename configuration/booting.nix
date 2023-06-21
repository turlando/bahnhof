{ lib, ... }:

{
  boot = {
    supportedFilesystems = [ "zfs" ];

    loader = {
      efi = {
        efiSysMountPoint = "/efi";
      };

      grub = {
        enable = true;
        device = "nodev";
        copyKernels = false;
        efiSupport = true;
        efiInstallAsRemovable = true;
        enableCryptodisk = true;
      };
    };

    initrd = {
      secrets = {
        "/boot/system.key" = "/boot/system.key";
      };

      luks.devices = {
        system = {
          device = "/dev/sda2";
          keyFile = "/boot/system.key";
          allowDiscards = true;
        };
      };

      postDeviceCommands = lib.mkAfter ''
        zfs rollback -r system/root@empty
      '';
    };
  };
}
