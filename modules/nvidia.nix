{ den, ... }:
{
  den.aspects.nvidia = {
    nixos = { ... }: {
      hardware.graphics.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        nvidiaSettings = true;
      };
      nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];
    };
  };
}
