{pkgs, ...}: {
  imports = [./waybar.nix];
  wayland.windowManager.hyprland.enable = false;
  programs.wofi.enable = true;
  services.hypridle.enable = true;
  services.hyprpaper.enable = true;
  wayland.windowManager.hyprland.settings = {
    "$mod" = "SUPER";
    general.border_size = 1;
    general.gaps_out = 8;
    general.gaps_in = 4;
    decoration = {
      rounding = 15;
      blur = {
        enabled = true;
        xray = true;
        special = false;
        new_optimizations = true;
        size = 14;
        passes = 4;
        brightness = 1;
        noise = 0.01;
        contrast = 1;
        popups = true;
        popups_ignorealpha = 0.6;
      };
      shadow.enabled = false;
      dim_inactive = true;
      dim_strength = 0.15;
    };
    input.natural_scroll = true;
    device = [
      {
        name = "asuf1205:00-2808:0106-touchpad";
        natural_scroll = true;
      }
      {
        name = "logitech-pebble-mouse";
        natural_scroll = true;
      }
    ];
    exec-once = ["waybar"];
    windowrule = [
      "float,title:^(Open File)(.*)$"
      "float,title:^(Select a File)(.*)$"
      "float,title:^(Choose wallpaper)(.*)$"
      "float,title:^(Open Folder)(.*)$"
      "float,title:^(Save As)(.*)$"
      "float,title:^(Library)(.*)$"
      "float,title:^(File Upload)(.*)$"
    ];
    windowrulev2 = ["size 800 600, class:firefox, title:Save As"];
    bind = let
      pactl = "${pkgs.pulseaudio}/bin/pactl";
      brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
    in
      [
        "$mod, W, exec, firefox"
        "$mod, Q, exec, kitty"
        "$mod, C, killactive"
        "$mod, M, exit"
        "$mod, SPACE, exec, wofi --show drun"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, b, exec, pkill waybar || waybar"
        "$mod, left, movefocus, l"
        "$mod, right, movefocus, r"
        "$mod, up, movefocus, u"
        "$mod, down, movefocus, d"
        "$mod, S, togglespecialworkspace, magic"
        "$mod SHIFT, S, movetoworkspace, special:magic"
        ",XF86AudioLowerVolume, exec, ${pactl} -- set-sink-volume 0 -10%"
        ",XF86AudioRaiseVolume, exec, ${pactl} -- set-sink-volume 0 +10%"
        ",XF86AudioMute, exec, ${pactl} -- set-sink-mute 0 toggle"
        ",XF86AudioMicMute, exec, ${pactl} -- set-source-mute 0 toggle"
        ",XF86MonBrightnessDown, exec, ${brightnessctl} s 10%-"
        ",XF86MonBrightnessUp, exec, ${brightnessctl} s +10%"
        ",XF86KbdBrightnessUp, exec, ${brightnessctl} -d asus::kbd_backlight s +10%"
        ",XF86KbdBrightnessDown, exec, ${brightnessctl} -d asus::kbd_backlight s 10%-"
      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (
            i: let
              ws = i + 1;
            in [
              "$mod, code:1${toString i}, workspace, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
  };
  wayland.windowManager.hyprland.plugins = [
    pkgs.hyprlandPlugins.hyprgrass
    pkgs.hyprlandPlugins.hyprtrails
  ];
  services.hypridle = {
    settings.general = {
      after_sleep_cmd = "hyprctl dispatch dpms on";
      ignore_dbus_inhibit = false;
      lock_cmd = "hyprlock";
    };
    settings.listener = [
      {
        timeout = 240;
        on-timeout = "hyprlock";
      }
      {
        timeout = 300;
        on-timeout = "hyprctl dispatch dpms off";
        on-resume = "hyprctl dispatch dpms on";
      }
    ];
  };
}
