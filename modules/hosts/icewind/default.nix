{ __findFile, ... }:
{
  den.aspects.icewind = {
    includes = [
      <hosts/server>
      <podman>
    ];

    nixos = {
      imports = [ ./_hardware-configuration.nix ];
    };
  };
}
