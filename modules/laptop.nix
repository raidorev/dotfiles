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
  };
}
