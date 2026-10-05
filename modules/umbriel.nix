{ inputs, lib, ... }:
let
  noctalia = cmd: "spawn:noctalia msg ${cmd}";

  lockedSpawn = cmd: {
    action = noctalia cmd;
    allow_when_locked = true;
  };

  once = action: {
    inherit action;
    repeat = false;
  };

  withCooldown = action: {
    inherit action;
    cooldown_ms = 150;
  };

  workspaceBinds = lib.mergeAttrsList (
    map (n: {
      "Mod+${toString n}" = "workspace-switch:${toString n}";
      "Mod+Ctrl+${toString n}" = "column-move-to-workspace:${toString n}";
    }) (lib.range 1 9)
  );
in
{
  flake-file.inputs.umbriel = {
    url = "github:noctalia-dev/umbriel";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.umbriel = { host, user, ... }: {
    nixos = {
      imports = [ inputs.umbriel.nixosModules.default ];

      programs.umbriel.enable = true;
      xdg.portal.config.umbriel."org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };

    homeManager = { config, ... }: {
      imports = [ inputs.umbriel.homeModules.default ];

      programs.umbriel = {
        enable = true;
        settings = {
          input = {
            keyboard = {
              layout = "us,ru";
              options = "grp:caps_toggle";
              numlock_toggle = true;
            };
            focus.follows_mouse = true;
          };

          appearance = {
            prefer_no_csd = true;
            border_width = 2;
            corner_radius = 8;
          };

          colors = with config.lib.stylix.colors.withHashtag; {
            backdrop = "${base00}FF";
            border = {
              focused = "${base0D}FF";
              unfocused = "${base03}FF";
            };
          };

          layout.gap = 8;

          window_rule = [
            {
              match.app_id = "^dev.noctalia.Noctalia$";
              default_floating = true;
            }
          ];

          layer_rule = [
            {
              match.namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd|desktop-widget-[^\"]*)$";
              blur = true;
              blur_ignore_alpha = 0.5;
              blur_popups = true;
              blur_optimized = false;
            }
          ];

          keybinds = workspaceBinds // {
            "Mod+Tab" = once "overview-toggle";
            "Mod+Shift+Slash" = once "cheatsheet-toggle";
            "Mod+Shift+Escape" = {
              action = "shortcuts-inhibit-toggle";
              allow_when_inhibited = true;
              repeat = false;
            };

            "Mod+T" = once "spawn:ghostty +new-window";
            "Mod+D" = once (noctalia "panel-toggle launcher");
            "Super+Alt+L" = once (noctalia "session lock");
            "Mod+P" = once (noctalia "panel-toggle session");

            "XF86AudioRaiseVolume" = lockedSpawn "volume-up";
            "XF86AudioLowerVolume" = lockedSpawn "volume-down";
            "XF86AudioMute" = lockedSpawn "volume-mute";
            "XF86AudioMicMute" = lockedSpawn "mic-mute";
            "XF86AudioPlay" = lockedSpawn "media toggle";
            "XF86AudioNext" = lockedSpawn "media next";
            "XF86AudioPrev" = lockedSpawn "media previous";
            "XF86MonBrightnessUp" = lockedSpawn "brightness-up";
            "XF86MonBrightnessDown" = lockedSpawn "brightness-down";

            "Mod+Q" = once "window-close";

            "Mod+H" = "window-focus-left";
            "Mod+J" = "window-focus-down";
            "Mod+K" = "window-focus-up";
            "Mod+L" = "window-focus-right";

            "Mod+Ctrl+H" = "column-move-left";
            "Mod+Ctrl+J" = "window-move-down";
            "Mod+Ctrl+K" = "window-move-up";
            "Mod+Ctrl+L" = "column-move-right";

            "Mod+Home" = "column-focus-first";
            "Mod+End" = "column-focus-last";
            "Mod+Ctrl+Home" = "column-move-to-first";
            "Mod+Ctrl+End" = "column-move-to-last";

            "Mod+Shift+H" = "output-focus-left";
            "Mod+Shift+J" = "output-focus-down";
            "Mod+Shift+K" = "output-focus-up";
            "Mod+Shift+L" = "output-focus-right";

            "Mod+Shift+Ctrl+H" = "column-move-to-output-left";
            "Mod+Shift+Ctrl+J" = "column-move-to-output-down";
            "Mod+Shift+Ctrl+K" = "column-move-to-output-up";
            "Mod+Shift+Ctrl+L" = "column-move-to-output-right";

            "Mod+U" = "workspace-next";
            "Mod+I" = "workspace-previous";
            "Mod+Ctrl+U" = "column-move-to-workspace-next";
            "Mod+Ctrl+I" = "column-move-to-workspace-previous";

            "Mod+Shift+U" = "workspace-move-down";
            "Mod+Shift+I" = "workspace-move-up";

            "Mod+WheelDown" = withCooldown "workspace-next";
            "Mod+WheelUp" = withCooldown "workspace-previous";
            "Mod+Ctrl+WheelDown" = withCooldown "column-move-to-workspace-next";
            "Mod+Ctrl+WheelUp" = withCooldown "column-move-to-workspace-previous";

            "Mod+WheelRight" = "window-focus-right";
            "Mod+WheelLeft" = "window-focus-left";
            "Mod+Ctrl+WheelRight" = "column-move-right";
            "Mod+Ctrl+WheelLeft" = "column-move-left";

            "Mod+Shift+WheelDown" = "window-focus-right";
            "Mod+Shift+WheelUp" = "window-focus-left";
            "Mod+Ctrl+Shift+WheelDown" = "column-move-right";
            "Mod+Ctrl+Shift+WheelUp" = "column-move-left";

            "Alt+Tab" = noctalia "window-switcher hold";
            "Alt+Shift+Tab" = noctalia "window-switcher hold";

            "Mod+Comma" = "window-consume-or-expel-left";
            "Mod+Period" = "window-consume-or-expel-right";

            "Mod+R" = "window-cycle-primary-extent";
            "Mod+Shift+R" = "window-cycle-secondary-extent";
            "Mod+F" = once "window-toggle-maximize";
            "Mod+Shift+F" = once "window-toggle-fullscreen";
            "Mod+C" = "column-center";

            "Mod+Minus" = "window-modify-primary-extent:-0.1";
            "Mod+Equal" = "window-modify-primary-extent:0.1";
            "Mod+Shift+Minus" = "window-modify-secondary-extent:-0.1";
            "Mod+Shift+Equal" = "window-modify-secondary-extent:0.1";

            "Print" = once (noctalia "screenshot-region");
            "Ctrl+Print" = once (noctalia "screenshot-fullscreen");

            "Mod+Shift+E" = once "session-quit";
            "Mod+Shift+P" = once "dpms-off";
          };
        };
      };
    };
  };
}
