{ den, ... }:
{
  den.aspects.nixos = { host, ... }: {
    includes = [
      den.aspects.boot
      den.aspects.locale
      den.aspects.nix-settings
      den.aspects.audio
      den.aspects.nvidia
    ];

    nixos = { pkgs, ... }: {
      imports = [ ../hosts/pc/hardware-configuration.nix ];

      networking.networkmanager.enable = true;

      programs.amnezia-vpn.enable = true;

      environment.systemPackages = with pkgs; [
        vim
        wget
        bitwarden-desktop
      ];
    };
  };
}
