{ lib, pkgs, stdenv, makeWrapper, ... }:

let
  buildInputs = [ pkgs.bemenu pkgs.lato ];
in
stdenv.mkDerivation {
  pname = "menu";
  version = "0.0.1";

  src = ./menu;

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = buildInputs;

  unpackCmd = ''
    mkdir src
    cp -p $curSrc src
  '';

  installPhase = ''
    install -m755 src/menu $out/bin/menu
    wrapProgram $out/bin/menu --prefix PATH : '${lib.makeBinPath buildInputs}'
  '';
}
