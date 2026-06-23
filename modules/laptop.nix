{ den, ... }:
{
  den.aspects.laptop = { host, ... }: {
    includes = [
      den.aspects.boot
      den.aspects.locale
      den.aspects.nix-settings
      den.aspects.audio
      den.aspects.git
      den.aspects.ghostty
      den.aspects.firefox
      den.aspects.zed
      den.aspects.stylix
      den.aspects.niri
      den.aspects.noctalia
      den.aspects.helium
      den.aspects.vesktop
      den.aspects.tailscale
    ];

    nixos = { pkgs, ... }: {
      imports = [ ../hosts/laptop/hardware-configuration.nix ];

      networking.networkmanager.enable = true;

      environment.systemPackages = with pkgs; [
        vim
        wget
      ];
    };
  };
}
