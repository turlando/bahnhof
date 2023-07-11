{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.lato
    pkgs.source-code-pro
  ];
}
