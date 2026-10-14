{ __findFile, ... }:
{
  den.aspects.volo = {
    includes = [
      <hosts/desktop>
      <nvidia>
      <podman>
    ];

    nixos = {
      imports = [ ./_hardware-configuration.nix ];
    };

    homeManager.programs.umbriel.settings.output."eDP-1".scale = 1.5;
  };
}
