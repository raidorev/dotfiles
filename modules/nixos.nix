{ __findFile, ... }:
{
  den.aspects.nixos = {
    includes = [
      <hosts/base>
      <podman>
      <tailscale>
      <wifi>
    ];

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
