{ __findFile, ... }:
{
  den.aspects.laptop = {
    includes = [
      <hosts/base>
      <podman>
      <amdgpu-firmware-fix>
    ];

    nixos = {
      imports = [ ../hosts/laptop/hardware-configuration.nix ];
    };
  };
}
