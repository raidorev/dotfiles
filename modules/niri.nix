{
  inputs,
  config,
  pkgs,
  ...
}:
let
  noctalia =
    cmd:
    [
      "noctalia-shell"
      "ipc"
      "call"
    ]
    ++ (pkgs.lib.splitString " " cmd);
in
{
  imports = [ inputs.niri.nixosModules.niri ];
  environment.systemPackages = with pkgs; [
    catppuccin-cursors
    catppuccin-papirus-folders
  ];

  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      niri = {
        prettyName = "Niri";
        comment = "Niri compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/niri";
      };
    };
  };

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri";
        user = "greeter";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
    config = {
      niri.default = [ "gtk" ];
    };
  };

  programs.niri.enable = true;
  home-manager.users.raidorev.programs.niri.settings = {
    spawn-at-startup = [
      { command = [ "noctalia-shell" ]; }
    ];
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
    outputs = {
      "eDP-1" = {
        backdrop-color = config.lib.stylix.colors.base00;
      };
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
      "Mod+D".action.spawn = noctalia "launcher toggle";
      "Super+Alt+L".action.spawn = noctalia "lockScreen lock";
      "Mod+P".action.spawn = noctalia "sessionMenu toggle";

      "XF86AudioRaiseVolume" = {
        allow-when-locked = true;
        action.spawn = noctalia "volume increase";
      };
      "XF86AudioLowerVolume" = {
        allow-when-locked = true;
        action.spawn = noctalia "volume decrease";
      };
      "XF86AudioMute" = {
        allow-when-locked = true;
        action.spawn = noctalia "volume muteOutput";
      };
      "XF86AudioMicMute" = {
        allow-when-locked = true;
        action.spawn = noctalia "volume muteInput";
      };
      "XF86AudioPlay" = {
        allow-when-locked = true;
        action.spawn = noctalia "media playPause";
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
        action.spawn = noctalia "brightness increase";
      };
      "XF86MonBrightnessDown" = {
        allow-when-locked = true;
        action.spawn = noctalia "brightness decrease";
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

      # Alternative commands that move across workspaces when reaching
      # the first or last window in a column.
      # Mod+J     { focus-window-or-workspace-down; }
      # Mod+K     { focus-window-or-workspace-up; }
      # Mod+Ctrl+J     { move-window-down-or-to-workspace-down; }
      # Mod+Ctrl+K     { move-window-up-or-to-workspace-up; }

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

      # Alternatively, there are commands to move just a single window:
      # Mod+Shift+Ctrl+Left  { move-window-to-monitor-left; }
      # ...

      # And you can also move a whole workspace to another monitor:
      # Mod+Shift+Ctrl+Left  { move-workspace-to-monitor-left; }
      # ...

      "Mod+U".action.focus-workspace-down = { };
      "Mod+I".action.focus-workspace-up = { };
      "Mod+Ctrl+U".action.move-column-to-workspace-down = { };
      "Mod+Ctrl+I".action.move-column-to-workspace-up = { };

      # Alternatively, there are commands to move just a single window:
      # Mod+Ctrl+Page_Down { move-window-to-workspace-down; }
      # ...

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

      # Usually scrolling up and down with Shift in applications results in
      # horizontal scrolling; these binds replicate that.
      "Mod+Shift+WheelScrollDown".action.focus-column-right = { };
      "Mod+Shift+WheelScrollUp".action.focus-column-left = { };
      "Mod+Ctrl+Shift+WheelScrollDown".action.move-column-right = { };
      "Mod+Ctrl+Shift+WheelScrollUp".action.move-column-left = { };

      # Similarly, you can bind touchpad scroll "ticks".
      # Touchpad scrolling is continuous, so for these binds it is split into
      # discrete intervals.
      # These binds are also affected by touchpad's natural-scroll, so these
      # example binds are "inverted", since we have natural-scroll enabled for
      # touchpads by default.
      # Mod+TouchpadScrollDown { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02+"; }
      # Mod+TouchpadScrollUp   { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.02-"; }

      # You can refer to workspaces by index. However, keep in mind that
      # niri is a dynamic workspace system, so these commands are kind of
      # "best effort". Trying to refer to a workspace index bigger than
      # the current workspace count will instead refer to the bottommost
      # (empty) workspace.
      #
      # For example, with 2 workspaces + 1 empty, indices 3, 4, 5 and so on
      # will all refer to the 3rd workspace.
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

      # Alternatively, there are commands to move just a single window:
      # Mod+Ctrl+1 { move-window-to-workspace 1; }

      "Alt+Tab".action.focus-workspace-previous = { };

      "Mod+Comma".action.consume-window-into-column = { };
      "Mod+Period".action.expel-window-from-column = { };

      # There are also commands that consume or expel a single window to the side.
      # Mod+BracketLeft  { consume-or-expel-window-left; }
      # Mod+BracketRight { consume-or-expel-window-right; }

      "Mod+R".action.switch-preset-column-width = { };
      "Mod+Shift+R".action.reset-window-height = { };
      "Mod+F".action.maximize-column = { };
      "Mod+Shift+F".action.fullscreen-window = { };
      "Mod+C".action.center-column = { };

      # Finer width adjustments.
      # This command can also:
      # * set width in pixels: "1000"
      # * adjust width in pixels: "-5" or "+5"
      # * set width as a percentage of screen width: "25%"
      # * adjust width as a percentage of screen width: "-10%" or "+10%"
      # Pixel sizes use logical, or scaled, pixels. I.e. on an output with scale 2.0,
      # set-column-width "100" will make the column occupy 200 physical screen pixels.
      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Equal".action.set-column-width = "+10%";

      # Finer height adjustments when in column with other windows.
      "Mod+Shift+Minus".action.set-window-height = "-10%";
      "Mod+Shift+Equal".action.set-window-height = "+10%";

      # Actions to switch layouts.
      # Note: if you uncomment these, make sure you do NOT have
      # a matching layout switch hotkey configured in xkb options above.
      # Having both at once on the same hotkey will break the switching,
      # since it will switch twice upon pressing the hotkey (once by xkb, once by niri).
      # Mod+Space       { switch-layout "next"; }
      # Mod+Shift+Space { switch-layout "prev"; }

      "Print".action.screenshot = { };
      "Ctrl+Print".action.screenshot-screen = { };
      "Alt+Print".action.screenshot-window = { };

      # The quit action will show a confirmation dialog to avoid accidental exits.
      "Mod+Shift+E".action.quit = { };

      # Powers off the monitors. To turn them back on, do any input like
      # moving the mouse or pressing any other key.
      "Mod+Shift+P".action.power-off-monitors = { };
    };
  };
}
