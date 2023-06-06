{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ./booting.nix
    ./network.nix
    ./users.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "23.05";
}
