{ pkgs, ... }:

let
  height = 20;
  font = "Lato:style=Bold:size=8";
  prompt = "Run:";
  normalBg = "#383C4A";
  selectBg = "#5294E2";
  normalText = "#D3DAE3";
  selectText = "#FFFFFF";

  menuScript = ''
  #!/bin/sh
  ${pkgs.bemenu}/bin/bemenu -b -i \
      -h ${height} \
      -fn ${font} \
      -p ${prompt} \
      -nb ${normalBg} \
      -sb ${selectBg} \
      -nf ${normalText} \
      -sf ${selectText}
  <&0
  '';

  menurunScript = ''
  #!/bin/sh
  ${pkgs.bemenu}/bin/bemenu-run -b -i \
      -h ${height} \
      -fn ${font} \
      -p ${prompt} \
      -nb ${normalBg} \
      -sb ${selectBg} \
      -nf ${normalText} \
      -sf ${selectText}
  <&0
  '';
in
{
  menu = pkgs.stdenv.mkDerivation {
    pname = "menu";
    version = "0.0.1";

    buildInputs = [
      pkgs.bemenu
      pkgs.lato
    ];

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      echo -n ${menuScript} > $out/bin/menu
      chmod +x $out/bin/menu
    '';
  };

  menu-run = pkgs.stdenv.mkDerivation {
    pname = "menu-run";
    version = "0.0.1";

    buildInputs = [
      pkgs.bemenu
      pkgs.lato
    ];

    dontUnpack = true;

    installPhase = ''
      mkdir -p $out/bin
      echo -n ${menurunScript} > $out/bin/menu-run
      chmod +x $out/bin/menu-run
    '';
  }
}
