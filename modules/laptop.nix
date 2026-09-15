{ __findFile, ... }:
{
  den.aspects.laptop = {
    includes = [
      <hosts/base>
      <amdgpu-firmware-fix>
    ];

    nixos = {
      imports = [ ../hosts/laptop/hardware-configuration.nix ];
    };
  };
}
