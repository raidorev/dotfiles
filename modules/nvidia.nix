{ __findFile, lib, ... }:
{
  den.schema.host.options.gpuPowerLimit = lib.mkOption {
    type = lib.types.nullOr lib.types.ints.positive;
    default = null;
    description = "NVIDIA GPU power limit in watts. Null leaves the card at its default.";
  };

  den.aspects.nvidia = { host, ... }: {
    includes = [
      (<den/unfree> [
        "nvidia-x11"
        "nvidia-settings"
      ])
    ];

    nixos =
      { config, lib, ... }:
      {
        boot.kernelParams = [
          "nvidia_drm.modeset=1"
          "nvidia_drm.fbdev=1"
          "initcall_blacklist=simpledrm_platform_driver_init"
        ];
        boot.initrd.kernelModules = [
          "nvidia"
          "nvidia_modeset"
          "nvidia_drm"
        ];
        hardware.graphics.enable = true;
        services.xserver.videoDrivers = [ "nvidia" ];
        hardware.nvidia = {
          modesetting.enable = true;
          open = true;
          nvidiaSettings = true;
          powerManagement.enable = true;
        };

        systemd.services = lib.optionalAttrs (host.gpuPowerLimit != null) {
          nvidia-power-limit = {
            description = "Set NVIDIA GPU power limit";
            wantedBy = [ "multi-user.target" ];
            after = [ "nvidia-persistenced.service" ];
            serviceConfig = {
              Type = "oneshot";
              ExecStart = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -pl ${toString host.gpuPowerLimit}";
              RemainAfterExit = true;
            };
          };
        };
      };
  };
}
