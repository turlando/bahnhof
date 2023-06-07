{ ... }:

{
  programs.home-manager.enable = true;

  home = {
    username = "tancredi";
    homeDirectory = "/home/tancredi";
    stateVersion = "23.05";
  };
}
