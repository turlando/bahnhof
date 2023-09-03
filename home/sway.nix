{ config, pkgs, localPkgs, ... }:

let
  cfg = config.wayland.windowManager.sway.config;
  m = cfg.modifier;
  terminal = "${pkgs.foot}/bin/foot";
  lsws = "${localPkgs.lsws}/bin/lsws";
  menu = "${localPkgs.menu}/bin/menu";
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

        "${m}+f" = "fullscreen";

        "${m}+v" = "splitv";
        "${m}+b" = "splith";

        "${m}+minus" = "floating toggle";
        "${m}+Shift+minus" = "focus mode_toggle";

        "${m}+r" = "mode resize";

        "${m}+q" = "kill";

        "${m}+minus" = "floating toggle";
        "${m}+Shift+minus" = "focus mode_toggle";

        "${m}+Tab" = "exec swaymsg workspace $(${lsws} | ${menu})";

        "${m}+u" = "workspace back_and_forth";
        "${m}+Shift+u" = "move container to workspace back_and_forth";
      };

      modes = {
        resize = {
          "h" = "resize shrink width 10 px";
          "j" = "resize grow height 10 px";
          "k" = "resize shrink height 10 px";
          "l" = "resize grow width 10 px";
          "Escape" = "mode default";
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
