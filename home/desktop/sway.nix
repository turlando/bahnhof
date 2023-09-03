{ config, pkgs, localPkgs, lib, ... }:

let
  cfg = config.wayland.windowManager.sway.config;
  m = cfg.modifier;

  terminal = "${pkgs.foot}/bin/foot";
  menu = "${localPkgs.menu}/bin/menu";
  menu-run = "${localPkgs.menu}/bin/menu -r";
  lsws = "${localPkgs.lsws}/bin/lsws";
in {
  wayland.windowManager.sway = {
    enable = true;

    config = {
      modifier = "Mod4";

      # menu = default.launcher;
      terminal = terminal;

      input = {
        "1:1:AT_Translated_Set_2_keyboard" = {
          xkb_layout  = "us";
          xkb_variant = "intl";
          xkb_options = "eurosign:e";
        };

        "1739:0:Synaptics_TM3075-002" = {
          accel_profile    = "adaptive";
          click_method     = "clickfinger";
          dwt              = "enabled";
          middle_emulation = "enabled";
          tap              = "enabled";
        };

        "2:10:TPPS/2_IBM_TrackPoint" = {
          dwt = "enabled";
        };
      };

      keybindings = {
        "${m}+Shift+e" = "exit";
        "${m}+Shift+r" = "reload";

        "${m}+q" = "kill";

        "${m}+h" = "focus left";
        "${m}+j" = "focus down";
        "${m}+k" = "focus up";
        "${m}+l" = "focus right";

        "${m}+Shift+h" = "move left";
        "${m}+Shift+j" = "move down";
        "${m}+Shift+k" = "move up";
        "${m}+Shift+l" = "move right";

        "${m}+a" = "focus parent";

        "${m}+s" = "layout stacking";
        "${m}+w" = "layout tabbed";
        "${m}+e" = "layout toggle split";

        "${m}+f" = "fullscreen toggle";

        "${m}+v" = "splitv";
        "${m}+b" = "splith";

        "${m}+Space" = "exec ${menu-run}";
        "${m}+Tab" = "exec swaymsg workspace $(${lsws} | ${menu})";

        "${m}+minus" = "floating toggle";
        "${m}+Shift+minus" = "focus mode_toggle";

        "${m}+r" = "mode resize";
      };

      fonts = {
        names = [ "Lato" ];
        style = "Bold";
        size = 8.0;
      };

      colors = {
        focused = {
          border = "#5294E2";
          background = "#5294E2";
          text = "#FFFFFF";
          indicator = "#2B2E39";
          childBorder = "#2B2E39";
        };
        unfocused = {
          border = "#2F343F";
          background = "#2F343F";
          text = "#D3DAE3";
          indicator = "#2B2E39";
          childBorder = "#2B2E39";
        };
        urgent = {
          border = "#F27835";
          background = "#F27835";
          text = "#D3DAE3";
          indicator = "#2B2E39";
          childBorder = "#2B2E39";
        };
      };

      bars = [];

      startup = [
        { command = "${pkgs.wayvnc}/bin/wayvnc -p 0.0.0.0"; }
        { command = terminal; }
      ];
    };

    wrapperFeatures.gtk = true;
  };
}
