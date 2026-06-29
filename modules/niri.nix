{ inputs, lib, ... }:
let
  noctalia =
    cmd:
    [
      "noctalia"
      "msg"
    ]
    ++ (lib.splitString " " cmd);
in
{
  flake-file.inputs.niri = {
    url = "github:sodiboo/niri-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.niri = { host, user, ... }: {
    nixos = { pkgs, ... }: {
      imports = [ inputs.niri.nixosModules.niri ];

      nix.settings = {
        extra-substituters = [ "https://niri.cachix.org" ];
        extra-trusted-public-keys = [ "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964=" ];
      };

      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri";
          user = "greeter";
        };
      };

      programs.niri.enable = true;
    };

    homeManager = { lib, pkgs, ... }: {
      programs.niri.settings = {
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        spawn-at-startup = [ { command = [ "noctalia" ]; } ];
        debug.honor-xdg-activation-with-invalid-serial = [ ];
        input = {
          keyboard = {
            numlock = true;
            xkb = {
              layout = "us,ru";
              options = "grp:alt_shift_toggle";
            };
          };
          focus-follows-mouse.enable = true;
        };
        prefer-no-csd = true;
        layout = {
          gaps = 8;
          border.width = 2;
          struts = {
            top = 0;
            right = 0;
            bottom = 0;
            left = 0;
          };
        };
        layer-rules = [
          {
            matches = [
              {
                namespace = "^noctalia-backdrop";
              }
            ];
            place-within-backdrop = true;
          }
        ];
        window-rules = [
          {
            geometry-corner-radius = {
              top-left = 8.0;
              top-right = 8.0;
              bottom-right = 8.0;
              bottom-left = 8.0;
            };
            clip-to-geometry = true;
          }
        ];
        binds = {
          "Mod+Tab".action.toggle-overview = { };
          "Mod+Shift+Slash".action.show-hotkey-overlay = { };

          "Mod+T".action.spawn = [
            "ghostty"
            "+new-window"
          ];
          "Mod+D".action.spawn = noctalia "panel-toggle launcher";
          "Super+Alt+L".action.spawn = noctalia "session lock";
          "Mod+P".action.spawn = noctalia "panel-toggle session";

          "XF86AudioRaiseVolume" = {
            allow-when-locked = true;
            action.spawn = noctalia "volume-up";
          };
          "XF86AudioLowerVolume" = {
            allow-when-locked = true;
            action.spawn = noctalia "volume-down";
          };
          "XF86AudioMute" = {
            allow-when-locked = true;
            action.spawn = noctalia "volume-mute";
          };
          "XF86AudioMicMute" = {
            allow-when-locked = true;
            action.spawn = noctalia "mic-mute";
          };
          "XF86AudioPlay" = {
            allow-when-locked = true;
            action.spawn = noctalia "media toggle";
          };
          "XF86AudioNext" = {
            allow-when-locked = true;
            action.spawn = noctalia "media next";
          };
          "XF86AudioPrev" = {
            allow-when-locked = true;
            action.spawn = noctalia "media previous";
          };
          "XF86MonBrightnessUp" = {
            allow-when-locked = true;
            action.spawn = noctalia "brightness-up";
          };
          "XF86MonBrightnessDown" = {
            allow-when-locked = true;
            action.spawn = noctalia "brightness-down";
          };

          "Mod+Q".action.close-window = { };

          "Mod+H".action.focus-column-left = { };
          "Mod+J".action.focus-window-down = { };
          "Mod+K".action.focus-window-up = { };
          "Mod+L".action.focus-column-right = { };

          "Mod+Ctrl+H".action.move-column-left = { };
          "Mod+Ctrl+J".action.move-window-down = { };
          "Mod+Ctrl+K".action.move-window-up = { };
          "Mod+Ctrl+L".action.move-column-right = { };

          "Mod+Home".action.focus-column-first = { };
          "Mod+End".action.focus-column-last = { };
          "Mod+Ctrl+Home".action.move-column-to-first = { };
          "Mod+Ctrl+End".action.move-column-to-last = { };

          "Mod+Shift+H".action.focus-monitor-left = { };
          "Mod+Shift+J".action.focus-monitor-down = { };
          "Mod+Shift+K".action.focus-monitor-up = { };
          "Mod+Shift+L".action.focus-monitor-right = { };

          "Mod+Shift+Ctrl+H".action.move-column-to-monitor-left = { };
          "Mod+Shift+Ctrl+J".action.move-column-to-monitor-down = { };
          "Mod+Shift+Ctrl+K".action.move-column-to-monitor-up = { };
          "Mod+Shift+Ctrl+L".action.move-column-to-monitor-right = { };

          "Mod+U".action.focus-workspace-down = { };
          "Mod+I".action.focus-workspace-up = { };
          "Mod+Ctrl+U".action.move-column-to-workspace-down = { };
          "Mod+Ctrl+I".action.move-column-to-workspace-up = { };

          "Mod+Shift+U".action.move-workspace-down = { };
          "Mod+Shift+I".action.move-workspace-up = { };

          "Mod+WheelScrollDown" = {
            cooldown-ms = 150;
            action.focus-workspace-down = { };
          };
          "Mod+WheelScrollUp" = {
            cooldown-ms = 150;
            action.focus-workspace-up = { };
          };
          "Mod+Ctrl+WheelScrollDown" = {
            cooldown-ms = 150;
            action.move-column-to-workspace-down = { };
          };
          "Mod+Ctrl+WheelScrollUp" = {
            cooldown-ms = 150;
            action.move-column-to-workspace-up = { };
          };

          "Mod+WheelScrollRight".action.focus-column-right = { };
          "Mod+WheelScrollLeft".action.focus-column-left = { };
          "Mod+Ctrl+WheelScrollRight".action.move-column-right = { };
          "Mod+Ctrl+WheelScrollLeft".action.move-column-left = { };

          "Mod+Shift+WheelScrollDown".action.focus-column-right = { };
          "Mod+Shift+WheelScrollUp".action.focus-column-left = { };
          "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = { };
          "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = { };

          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;
          "Mod+Ctrl+1".action.move-column-to-workspace = 1;
          "Mod+Ctrl+2".action.move-column-to-workspace = 2;
          "Mod+Ctrl+3".action.move-column-to-workspace = 3;
          "Mod+Ctrl+4".action.move-column-to-workspace = 4;
          "Mod+Ctrl+5".action.move-column-to-workspace = 5;
          "Mod+Ctrl+6".action.move-column-to-workspace = 6;
          "Mod+Ctrl+7".action.move-column-to-workspace = 7;
          "Mod+Ctrl+8".action.move-column-to-workspace = 8;
          "Mod+Ctrl+9".action.move-column-to-workspace = 9;

          "Alt+Tab".action.focus-workspace-previous = { };

          "Mod+Comma".action.consume-window-into-column = { };
          "Mod+Period".action.expel-window-from-column = { };

          "Mod+R".action.switch-preset-column-width = { };
          "Mod+Shift+R".action.reset-window-height = { };
          "Mod+F".action.maximize-column = { };
          "Mod+Shift+F".action.fullscreen-window = { };
          "Mod+C".action.center-column = { };

          "Mod+Minus".action.set-column-width = "-10%";
          "Mod+Equal".action.set-column-width = "+10%";
          "Mod+Shift+Minus".action.set-window-height = "-10%";
          "Mod+Shift+Equal".action.set-window-height = "+10%";

          "Print".action.screenshot = { };
          "Ctrl+Print".action.screenshot-screen = { };
          "Alt+Print".action.screenshot-window = { };

          "Mod+Shift+E".action.quit = { };
          "Mod+Shift+P".action.power-off-monitors = { };
        };

      };
    };
  };
}
