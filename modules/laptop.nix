{ den, ... }:
{
  den.aspects.laptop = {
    includes = [
      den.aspects.boot
      den.aspects.locale
      den.aspects.nix-settings
      den.aspects.git
      den.aspects.ghostty
      den.aspects.wofi
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
      imports = [ ../_legacy/hosts/laptop/hardware-configuration.nix ];

      networking = {
        hostName = "raidorev";
        networkmanager.enable = true;
      };

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };

      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        wireplumber.enable = true;
      };

      services.power-profiles-daemon.enable = true;
      services.upower.enable = true;

      environment.systemPackages = with pkgs; [
        vim
        wget
        nixfmt
        nixd
        qt6.qtdeclarative
        kooha
      ];
    };
  };
}
