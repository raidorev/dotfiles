{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/nix.nix
    ../../modules/users.nix
    ../../modules/locale.nix
    ../../modules/niri.nix
    ../../modules/noctalia.nix
    ../../modules/wofi.nix
    ../../modules/firefox.nix
    ../../modules/helium.nix
    ../../modules/stylix.nix
    ../../modules/fish.nix
    ../../modules/git.nix
    ../../modules/ghostty.nix
    ../../modules/zed.nix
    # ../../modules/vesktop.nix
    # ../../modules/tailscale.nix
  ];

  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

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

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    nixfmt
    nixd
    qt6.qtdeclarative
    kooha
  ];

  system.stateVersion = "25.11";
}
