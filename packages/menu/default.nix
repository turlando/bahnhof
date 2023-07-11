{ pkgs, ... }:

let
  height = "20";
  font = "Lato:style=Bold:size=8";
  prompt = "Run:";
  normalBg = "#383C4A";
  selectBg = "#5294E2";
  normalText = "#D3DAE3";
  selectText = "#FFFFFF";

  script = pkgs.writeShellScriptBin "menu-run" ''
  ${pkgs.bemenu}/bin/bemenu-run -b -i \
      -h ${height} \
      --fn ${font} \
      -p "${prompt}" \
      --nb ${normalBg} \
      --sb ${selectBg} \
      --nf ${normalText} \
      --sf ${selectText} \
  <&0
  '';
in
pkgs.stdenv.mkDerivation {
  pname = "menu-run";
  version = "0.0.1";

  buildInputs = [
    pkgs.bemenu
    pkgs.lato
  ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -p ${script}/bin/menu-run $out/bin/menu-run
  '';
}
