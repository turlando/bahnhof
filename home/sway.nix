{ config, pkgs, lib, default, ... }:

let
  m = config.wayland.windowManager.sway.config.modifier;
  terminal = "${pkgs.mate.mate-terminal/bin/mate-terminal}";
in {
  wayland.windowManager.sway = {
    enable = true;

    modifier = "Mod4";

    # menu = default.launcher;
    terminal = terminal;

    config = {
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

        "${m}+f" = "fullscreen";

        "${m}+v" = "splitv";
        "${m}+b" = "splith";

        "${m}+minus" = "floating toggle";
        "${m}+Shift+minus" = "focus mode_toggle";

        "${m}+Return" = "exec ${terminal}";
      };
    };

    wrapperFeatures.gtk = true;
  };
}
