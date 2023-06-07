{ pkgs, localPkgs, ... }:

{
  home.packages = [
    localPkgs.lsws
  ];
}
