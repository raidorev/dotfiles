{ __findFile, ... }:
{
  den.hosts.x86_64-linux.nixos = {
    users.raidorev = { };
    gpuPowerLimit = 230;
    ddcMonitor = true;
  };
  den.hosts.x86_64-linux.laptop.users.raidorev = { };

  den.aspects.hosts.base = {
    includes = [
      <den/host-aspects>
      <boot>
      <locale>
      <nix-settings>
      <bluetooth>
      <pipewire>
      <power>
      <nvidia>

      (<den/insecure> [ "pnpm-10.29.2" ])
    ];

    nixos = { pkgs, ... }: {
      networking.networkmanager.enable = true;
      programs.amnezia-vpn.enable = true;
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
