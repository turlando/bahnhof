{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "menu";
  version = "0.0.1";

  buildInputs = [
    pkgs.bemenu
    pkgs.lato
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ${./menu} $out/bin/menu
    chmod +x $out/bin/menu
  '';
}
