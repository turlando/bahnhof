{ pkgs, ... }:

{
  lsws = pkgs.callPackage ./lsws {};
  menu-run = pkgs.callPackage ./menu {};
}
