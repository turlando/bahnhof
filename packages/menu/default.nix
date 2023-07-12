{ lib, pkgs, stdenv, makeWrapper, ... }:

let
  buildInputs = [ pkgs.bemenu pkgs.lato ];
in
stdenv.mkDerivation {
  pname = "menu";
  version = "0.0.1";

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = buildInputs;

  dontUnpack = true;

  installPhase = ''
    install -m755 ${./menu} $out/bin/menu
    wrapProgram $out/bin/menu --prefix PATH : '${lib.makeBinPath buildInputs}'
  '';
}
