{ inputs, lib, ... }:
{
  den.schema.host.options.ddcMonitor = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether this host drives a monitor over DDC/CI.";
  };

  flake-file.inputs = {
    noctalia.url = "github:noctalia-dev/noctalia";
    noctalia-greeter.url = "github:noctalia-dev/noctalia-greeter";
  };

  den.aspects.noctalia = { host, user, ... }: {
    nixos =
      { pkgs, lib, ... }:
      {
        imports = [
          inputs.noctalia-greeter.nixosModules.default
        ];
        environment.systemPackages = [
          inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
        ]
        ++ lib.optional host.ddcMonitor pkgs.ddcutil;

        nix.settings = {
          extra-substituters = [ "https://noctalia.cachix.org" ];
          extra-trusted-public-keys = [
            "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
          ];
        };

        services.displayManager.noctalia-greeter = {
          enable = true;

          settings = {
            appearance.scheme = "Catppuccin";
            cursor = {
              theme = "catppuccin-mocha-rosewater-cursors";
              # See: https://github.com/nix-community/stylix/issues/2223
              path = "${
                inputs.nixpkgs-stable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.catppuccin-cursors.mochaRosewater
              }/share/icons";
              size = 24;
            };
          };
        };
      };

    homeManager = {
      imports = [ inputs.noctalia.homeModules.default ];

      home.file.".face".source = ../profile.png;
      home.file.wallpapers.source = ../wallpapers;

      programs.noctalia = {
        enable = true;
        systemd.enable = true;
        settings = {
          wallpaper.enable = true;
          theme = {
            builtin = "Catppuccin";
            templates = {
              enable_builtin_templates = false;
              enable_community_templates = false;
            };
          };
          backdrop = {
            enabled = true;
            blur_intensity = 0.5;
            tint_intensity = 0.3;
          };

          brightness = {
            enable_ddcutil = host.ddcMonitor;
            minimum_brightness = 0.01;
          };

          idle.behavior = {
            lock = {
              timeout = 300;
              action = "lock";
              enabled = true;
            };

            screen-off = {
              timeout = 350;
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
            cat.type = "noctalia/bongocat:cat";
          };

          bar = {
            default = {
              margin_ends = 0;
              concave_edge_corners = true;
              radius = 12;

              start = [
                "launcher"
                "weather"
                "sysmon"
                "workspaces"
                "media"
                "cat"
              ];
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
            };
          };
        };
      };
    };
  };
}
