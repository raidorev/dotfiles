{ __findFile, ... }:
{
  den.hosts.x86_64-linux.waterdeep = {
    users.raidorev = { };
    gpuPowerLimit = 230;
    ddcMonitor = true;
  };
  den.hosts.x86_64-linux.volo.users.raidorev = { };
  # Enable once modules/hosts/icewind/_hardware-configuration.nix exists.
  # den.hosts.x86_64-linux.icewind.users.raidorev = { };

  den.aspects.hosts.base = {
    includes = [
      <den/host-aspects>
      <boot>
      <locale>
      <nix-settings>
      <tailscale>

      (<den/insecure> [ "pnpm-10.29.2" ])
    ];

    nixos = { pkgs, ... }: {
      networking.networkmanager.enable = true;
      documentation.man.enable = false;
      environment.systemPackages = with pkgs; [
        vim
        wget
      ];
      zramSwap.enable = true;
      programs.nix-ld.enable = true;
    };
  };
}
