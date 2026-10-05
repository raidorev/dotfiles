{ __findFile, ... }:
{
  den.aspects.laptop = {
    includes = [
      <hosts/base>
      <podman>
    ];

    nixos = {
      imports = [ ../hosts/laptop/hardware-configuration.nix ];
    };

    homeManager.programs.umbriel.settings.output."eDP-1".scale = 1.5;
  };
}
