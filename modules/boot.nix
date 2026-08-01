{
  den.aspects.boot = { host }: {
    nixos = { pkgs, ... }: {
      boot = {
        loader = {
          limine = {
            enable = true;
            resolution = "2560x1440";
            maxGenerations = 8;
          };
          efi.canTouchEfiVariables = true;
        };
        kernelParams = [
          "nvidia_drm.modeset=1"
          "nvidia_drm.fbdev=1"
          "initcall_blacklist=simpledrm_platform_driver_init"
        ];
        kernelPackages = pkgs.linuxPackages_latest;

        plymouth.enable = true;
      };
    };
  };
}
