{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./booting.nix
    ./storage.nix
    ./network.nix
    ./users.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "23.05";
}
