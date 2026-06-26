{ den, ... }:
{
  den.aspects.nvidia = { host, ... }: {
    includes = [
      (den.provides.unfree [
        "nvidia-x11"
        "nvidia-settings"
      ])
    ];

    nixos = {
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        nvidiaSettings = true;
      };
    };
  };
}
