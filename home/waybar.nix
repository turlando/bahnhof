{ ... }:

{
  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      target = "sway-session.target";
    };

    settings = {
      main = {
        layer = "bottom";
        output = [ "eDP-1" ];
        position = "bottom";

        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];

        modules-right = [
          "clock"
        ];
      };
    };
  };
}
