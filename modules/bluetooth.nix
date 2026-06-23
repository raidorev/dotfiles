{ den, ... }:
{
  den.aspects.bluetooth = { host, ... }: {
    nixos = {
      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
    };
  };
}
