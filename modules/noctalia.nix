{ inputs, lib, ... }:
{
  den.schema.host.options.ddcMonitor = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether this host drives a monitor over DDC/CI.";
  };

  den.schema.host.options.noctaliaConfig = lib.mkOption {
    type = lib.types.nullOr lib.types.path;
    default = null;
    description = "Exported noctalia config.tom.";
  };

  flake-file.inputs = {
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  den.aspects.noctalia =
    { host, user, ... }:
    let
      configFile = host.noctaliaConfig;
      missing = configFile != null && !builtins.pathExists configFile;
      useConfig = configFile != null && !missing;
    in
    {
      user.extraGroups = lib.optional host.ddcMonitor "i2c";

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

          hardware.i2c.enable = host.ddcMonitor;

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

        warnings = lib.optional missing "noctalia: ${toString configFile} not found; falling back to stylix defaults.";

        home.file.".face".source = ../profile.png;
        home.file.wallpapers.source = ../wallpapers;

        stylix.targets.noctalia.image.enable = !useConfig;

        programs.noctalia = {
          enable = true;
          systemd.enable = true;
          settings = lib.optionalAttrs useConfig (fromTOML (builtins.readFile configFile));
        };
      };
    };
}
