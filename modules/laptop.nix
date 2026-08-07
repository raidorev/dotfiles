{ __findFile, ... }:
{
  den.aspects.laptop = {
    includes = [ <hosts/base> ];

    nixos = {
      imports = [ ../hosts/laptop/hardware-configuration.nix ];
    };
  };
}
