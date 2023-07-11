{ pkgs, ... }:

{
  lsws = pkgs.callPackage ./lsws {};
  menu = pkgs.callPackage (import ./menu).menu {};
  menu-run = pkgs.callPackage (import ./menu).menu-run {};
}
