{ __findFile, ... }:
{
  den.aspects.laptop = { host, ... }: {
    includes = [ <hosts/base> ];

    nixos = {
      imports = [ ../hosts/laptop/hardware-configuration.nix ];
    };
  };
}
