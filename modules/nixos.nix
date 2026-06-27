{ __findFile, ... }:
{
  den.aspects.nixos = { host, ... }: {
    includes = [ <hosts/base> ];

    nixos = {
      imports = [ ../hosts/pc/hardware-configuration.nix ];
    };

    homeManager = { config, ... }: {

      programs.niri.settings.outputs."DP-1" = {
        mode = {
          width = 2560;
          height = 1440;
        };
        backdrop-color = config.lib.stylix.colors.base00;
      };
    };
  };
}
