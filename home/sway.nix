{ config, pkgs, lib, ... }:

let
  cfg = config.wayland.windowManager.sway.config;
  m = cfg.modifier;
  terminal = "${pkgs.mate.mate-terminal}/bin/mate-terminal";
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
          accel_profile    = "adaptative";
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

        "${m}+minus" = "floating toggle";
        "${m}+Shift+minus" = "focus mode_toggle";
      };

      startup = [
        { command = "${pkgs.wayvnc}/bin/wayvnc"; }
      ];
    };

    wrapperFeatures.gtk = true;
  };
}
