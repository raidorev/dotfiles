{ __findFile, ... }:
{
  den.aspects.nixos = { host, ... }: {
    includes = [
      <boot>
      <locale>
      <nix-settings>
      <audio>
      <nvidia>
    ];

    nixos = { pkgs, ... }: {
      imports = [ ../hosts/pc/hardware-configuration.nix ];

      networking.networkmanager.enable = true;

      programs.amnezia-vpn.enable = true;

      environment.systemPackages = with pkgs; [
        vim
        wget
      ];
    };
  };
}
