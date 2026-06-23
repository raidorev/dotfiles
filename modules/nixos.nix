{ den, ... }:
{
  den.aspects.nixos = {
    includes = [
      den.aspects.boot
      den.aspects.locale
      den.aspects.nix-settings
      den.aspects.audio
      den.aspects.nvidia
      den.aspects.git
      den.aspects.ghostty
      den.aspects.wofi
      den.aspects.firefox
      den.aspects.zed
      # den.aspects.stylix
      den.aspects.niri
      den.aspects.noctalia
      den.aspects.helium
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
