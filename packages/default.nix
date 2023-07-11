{ pkgs, ... }:

let
  menu = import ./menu;
in
{
  lsws = pkgs.callPackage ./lsws {};
  menu = pkgs.callPackage menu.menu {};
  menu-run = pkgs.callPackage menu.menu-run {};
}
