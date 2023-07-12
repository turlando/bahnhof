{ pkgs, ... }:

{
  lsws = pkgs.callPackage ./lsws {};
  menu = pkgs.callPackage ./menu {};
}
