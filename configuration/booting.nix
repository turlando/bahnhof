{ ... }:

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
          keyFile = "/boot/system.key";
        };
      };

      postDeviceCommands = mkAfter ''
        zfs rollback -r system/root@empty
      '';
    };
  };
}
