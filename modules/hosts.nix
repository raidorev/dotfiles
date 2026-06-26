{ __findFile, ... }:
{
  den.hosts.x86_64-linux.nixos.users.raidorev = { };
  den.hosts.x86_64-linux.laptop.users.raidorev = { };

  den.aspects.hosts.base = { host, ... }: {
    includes = [
      <den/host-aspects>
      <boot>
      <locale>
      <nix-settings>
      <bluetooth>
      <pipewire>
      <power>
      <nvidia>
    ];

    nixos = { pkgs, ... }: {
      networking.networkmanager.enable = true;
      programs.amnezia-vpn.enable = true;
      environment.systemPackages = with pkgs; [
        vim
        wget
      ];
    };
  };
}
