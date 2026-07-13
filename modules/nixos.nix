{ __findFile, ... }:
{
  den.aspects.nixos = { host, ... }: {
    includes = [
      <hosts/base>
      <podman>
    ];

    nixos = { pkgs, config, ... }: {
      imports = [ ../hosts/pc/hardware-configuration.nix ];

      programs.nix-ld.enable = true;

      environment.systemPackages = with pkgs; [
        qemu
        quickemu
      ];

      services.zerotierone.enable = true;

      systemd.services.nvidia-power-limit = {
        description = "Set NVIDIA GPU power limit";
        wantedBy = [ "multi-user.target" ];
        after = [ "nvidia-persistenced.service" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${config.hardware.nvidia.package.bin}/bin/nvidia-smi -pl 230";
          RemainAfterExit = true;
        };
      };
    };

    homeManager = { config, ... }: {
      programs.niri.settings.outputs."DP-1" = {
        mode = {
          width = 2560;
          height = 1440;
        };
        backdrop-color = config.lib.stylix.colors.base00;
      };
    };
  };
}
