{ den, ... }:
{
  den.aspects.audio = { host, ... }: {
    includes = [
      den.aspects.bluetooth
      den.aspects.pipewire
      den.aspects.power
    ];
  };
}
