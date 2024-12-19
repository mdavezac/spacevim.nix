{
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [./swayidle.nix ./waybar.nix ./swaybg.nix];

  home.packages = [
    pkgs.brightnessctl
    pkgs.fuzzel
    pkgs.swaylock
  ];

  programs.niri = {
    settings = {
      input = {
        keyboard.xkb.layout = "us";
        mouse.accel-speed = 1.0;
        touchpad = {
          tap = true;
          dwt = true;
          natural-scroll = true;
          click-method = "clickfinger";
        };
      };

      layout = {
        gaps = 16;
        struts.left = 64;
        struts.right = 64;
        border.width = 4;
      };

      hotkey-overlay.skip-at-startup = true;
      outputs."eDP-1".scale = 2.0;
      binds = with pkgs.lib; let
        binds = {
          suffixes,
          prefixes,
          substitutions ? {},
        }: let
          replacer = replaceStrings (attrNames substitutions) (attrValues substitutions);
          mapper = {
            prefix,
            suffix,
          }: let
            actual-suffix =
              if isList suffix.value
              then {
                action = head suffix.value;
                args = tail suffix.value;
              }
              else {
                action = suffix.value;
                args = [];
              };
            action = replacer "${prefix.value}-${actual-suffix.action}";
          in {
            name = "${prefix.name}+${suffix.name}";
            value.action.${action} = actual-suffix.args;
          };
        in
          listToAttrs (
            mapCartesianProduct mapper {
              prefix = attrsToList prefixes;
              suffix = attrsToList suffixes;
            }
          );
      in
        with config.lib.niri.actions; let
          sh = spawn "sh" "-c";
        in
          lib.attrsets.mergeAttrsList [
            {
              "Mod+T".action = spawn "kitty";
              "Mod+D".action = spawn "fuzzel";
              "Mod+W".action = sh (builtins.concatStringsSep "; " [
                "systemctl --user restart waybar.service"
                "systemctl --user restart swaybg.service"
              ]);

              "Mod+L".action = spawn "blurred-locker";

              "XF86AudioRaiseVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
              "XF86AudioLowerVolume".action = sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
              "XF86AudioMute".action = sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";

              "XF86MonBrightnessUp".action = sh "brightnessctl set 10%+";
              "XF86MonBrightnessDown".action = sh "brightnessctl set 10%-";

              "Mod+Q".action = close-window;

              "XF86AudioNext".action = focus-column-right;
              "XF86AudioPrev".action = focus-column-left;

              "Mod+Tab".action = focus-window-down-or-column-right;
              "Mod+Shift+Tab".action = focus-window-up-or-column-left;
            }
            (binds {
              suffixes."Left" = "column-left";
              suffixes."Down" = "window-down";
              suffixes."Up" = "window-up";
              suffixes."Right" = "column-right";
              prefixes."Mod" = "focus";
              prefixes."Mod+Ctrl" = "move";
              prefixes."Mod+Shift" = "focus-monitor";
              prefixes."Mod+Shift+Ctrl" = "move-window-to-monitor";
              substitutions."monitor-column" = "monitor";
              substitutions."monitor-window" = "monitor";
            })
            (binds {
              suffixes."Home" = "first";
              suffixes."End" = "last";
              prefixes."Mod" = "focus-column";
              prefixes."Mod+Ctrl" = "move-column-to";
            })
            (binds {
              suffixes."U" = "workspace-down";
              suffixes."I" = "workspace-up";
              prefixes."Mod" = "focus";
              prefixes."Mod+Ctrl" = "move-window-to";
              prefixes."Mod+Shift" = "move";
            })
            (binds {
              suffixes = builtins.listToAttrs (map (n: {
                name = toString n;
                value = ["workspace" n];
              }) (range 1 9));
              prefixes."Mod" = "focus";
              prefixes."Mod+Ctrl" = "move-window-to";
            })
            {
              "Mod+Comma".action = consume-window-into-column;
              "Mod+Period".action = expel-window-from-column;

              "Mod+R".action = switch-preset-column-width;
              "Mod+F".action = maximize-column;
              "Mod+Shift+F".action = fullscreen-window;
              "Mod+C".action = center-column;

              "Mod+Minus".action = set-column-width "-10%";
              "Mod+Equal".action = set-column-width "+10%";
              "Mod+Shift+Minus".action = set-window-height "-10%";
              "Mod+Shift+Equal".action = set-window-height "+10%";

              "Mod+Shift+E".action = quit;
              "Mod+Shift+P".action = power-off-monitors;

              "Mod+Shift+Ctrl+T".action = toggle-debug-tint;
            }
          ];
    };
  };
}
