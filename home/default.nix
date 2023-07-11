{ ... }:

{
  imports = [
    ./packages.nix
    ./fonts.nix
    ./desktop
  ];

  programs.home-manager.enable = true;

  home = {
    username = "tancredi";
    homeDirectory = "/home/tancredi";
    stateVersion = "23.05";
  };

  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };
}
