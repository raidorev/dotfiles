{
  den.aspects.power = {
    nixos = {
      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;
    };
  };
}
