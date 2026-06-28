{ inputs, ... }:
{
  flake-file.inputs.noctalia = {
    url = "github:noctalia-dev/noctalia";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.noctalia = { host, user, ... }: {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
        pkgs.ddcutil
      ];

      nix.settings = {
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
    };

    homeManager = { config, ... }: {
      imports = [ inputs.noctalia.homeModules.default ];

      home.file.".face".source = ../profile.png;
      home.file.wallpapers.source = ../wallpapers;

      programs.noctalia = {
        enable = true;
        settings = {
          theme = {
            builtin = "Catppuccin";
            templates = {
              enable_builtin_templates = false;
              enable_community_templates = false;
            };
          };
          wallpaper = {
            enabled = true;
            directory = "${config.home.homeDirectory}/wallpapers";
            default = "${config.home.homeDirectory}/wallpapers/cabin-2.jpg";
          };
          backdrop = {
            enabled = true;
            blur_intensity = 0.5;
            tint_intensity = 0.3;
          };

          brightness = {
            enable_ddcutil = true;
            minimum_brightness = 0.01;
          };

          idle.behavior = {
            lock = {
              timeout = 5;
              action = "lock";
              enabled = true;
            };

            screen-off = {
              timeout = 10;
              action = "screen_off";
              enabled = true;
            };
          };

          dock = {
            auto_hide = true;
            enabled = true;
            reserve_space = false;
          };

          location.address = "St Petersburg";

          plugins = {
            enabled = [ "noctalia/bongocat" ];
          };

          shell = {
            niri_overview_type_to_launch_enabled = true;
            panel = {
              open_near_click_control_center = true;
              open_near_click_launcher = true;
            };
          };

          widget = {
            launcher = {
              glyph = "cat";
            };
            workspaces = {
              empty_color = "surface";
              occupied_color = "surface";
            };
          };

          bar = {
            default = {
              center = [ "active_window" ];
              end = [
                "tray"
                "notifications"
                "clipboard"
                "network"
                "bluetooth"
                "volume"
                "brightness"
                "control-center"
                "session"
              ];
              margin_ends = 10;
              start = [
                "launcher"
                "weather"
                "sysmon"
                "workspaces"
                "media"
              ];
            };
          };
        };
      };
    };
  };
}
