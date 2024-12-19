{pkgs, ...}: {
  home.packages = [pkgs.blueman pkgs.pavucontrol];

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings.main-bar = {
      layer = "top";
      height = 28;
      spacing = 8;
      modules-left = ["wlr/taskbar"];
      modules-right = [
        "wireplumber"
        "network"
        "bluetooth"
        "battery"
        "clock"
      ];
      "wlr/taskbar" = {
        on-click = "activate";
        tooltip-format = "{title} | {app_id}";
      };
      wireplumber = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 {volume}%";
        format-icons = [
          "󰕿"
          "󰖀"
          "󰕾"
        ];
        reverse-scrolling = 1;
        on-click = "pavucontrol";
      };
      network = {
        tooltip-format = "{ifname}";
        format-disconnected = "󰤮";
        format-ethernet = "󰈀";
        format-wifi = "{icon}  {essid}";
        format-icons = [
          "󰤟"
          "󰤢"
          "󰤥"
          "󰤨"
        ];
      };
      bluetooth = {
        format = "{icon}";
        format-disabled = "";
        format-connected = "{icon} {device_battery_percentage}%";
        format-icons = {
          off = "󰂲";
          on = "󰂯";
          connected = "󰂱";
        };
        on-click = "blueman-manager";
      };
      battery = {
        interval = 5;
        format = "{icon} {capacity}%";
        format-charging = "{icon} {capacity}% 󱐋";
        format-icons = [
          "󰁺"
          "󰁻"
          "󰁼"
          "󰁽"
          "󰁾"
          "󰁿"
          "󰂀"
          "󰂁"
          "󰂂"
          "󰁹"
        ];
        states.warning = 30;
        states.critical = 15;
      };
      clock = {
        interval = 1;
        format = "{:%Y-%m-%d (%a) %H:%M:%S}";
      };
    };
    style = ''
      tooltip label {
        color: black;
        text-shadow: none;
      }
      #battery.warning:not(.charging) {
        color: #770;
      }
      #battery.critical:not(.charging) {
        background: red;
        color: white;
      }
    '';
  };

  systemd.user.services.waybar.Unit = {
    After = ["niri.service"];
    Requires = ["niri.service"];
  };
}
