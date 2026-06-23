{ den, ... }:
{
  den.aspects.audio = {
    includes = [
      den.aspects.bluetooth
      den.aspects.pipewire
      den.aspects.power
    ];
  };
}
