{ pkgs, ... }:

pkgs.stdenv.mkDerivation {
  pname = "lsws";
  version = "0.0.1";

  buildInputs = [
    pkgs.sway
    pkgs.coreutils
    pkgs.gnugrep
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp ${./lsws} $out/bin/lsws
    chmod +x $out/bin/lsws
  '';
}
