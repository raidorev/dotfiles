{ den, ... }:
{
  den.aspects.nixos = {
    includes = [
      den.aspects.boot
      den.aspects.locale
      den.aspects.nix-settings
      den.aspects.git
      den.aspects.ghostty
      den.aspects.wofi
      den.aspects.firefox
      den.aspects.zed
      # den.aspects.stylix    # TODO: needs stylix input
      # den.aspects.niri      # TODO: needs niri input
      # den.aspects.noctalia  # TODO: needs noctalia input
      # den.aspects.helium    # TODO: needs helium input
    ];

    nixos = { pkgs, ... }: {
      imports = [ ../_legacy/hosts/pc/hardware-configuration.nix ];

      networking = {
        hostName = "nixos";
        networkmanager.enable = true;
      };

      programs.amnezia-vpn.enable = true;

      hardware.graphics.enable = true;
      services.xserver.videoDrivers = [ "nvidia" ];
      hardware.nvidia = {
        modesetting.enable = true;
        open = true;
        nvidiaSettings = true;
      };

      nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];

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
        bitwarden-desktop
      ];
    };
  };
}
