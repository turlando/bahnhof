{ ... }:

{
  fileSystems = {
    "/" = {
      device = "/dev/sda2";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

    "/boot" = {
      device = "/dev/sda1";
      fsType = "vfat";
    };

    "/nix" = {
      device = "/dev/sda2";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

    "/var/state" = {
      device = "/dev/sda2";
      fsType = "btrfs";
      options = [ "subvol=state" "compress=zstd" "noatime" ];
    };

    "/var/log" = {
      device = "/dev/sda2";
      fsType = "btrfs";
      options = [ "subvol=log" "compress=zstd" "noatime" ];
      neededForBoot = true;
    };

    "/home" = {
      device = "/dev/sda2";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };
  };

  swapDevices = [ ];
}
