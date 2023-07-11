{ pkgs, ... }:

{
  lsws = pkgs.callPackage ./lsws {};
  menu = pkgs.callPackage (import ./menu { pkgs = pkgs }).menu {};
  menu-run = pkgs.callPackage (import ./menu { pkgs = pkgs }).menu-run {};
}
