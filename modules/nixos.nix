{ __findFile, ... }:
{
  den.aspects.nixos = {
    includes = [
      <hosts/base>
      <podman>
      <tailscale>
    ];

    nixos = {
      imports = [ ../hosts/pc/hardware-configuration.nix ];

      zramSwap.enable = true;

      programs.nix-ld.enable = true;
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
