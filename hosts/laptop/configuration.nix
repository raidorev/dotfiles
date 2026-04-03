{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/boot.nix
    ../../modules/nix.nix
    ../../modules/users.nix
    ../../modules/locale.nix
    ../../modules/hyprland/hyprland.nix
    ../../modules/quickshell/quickshell.nix
    ../../modules/niri.nix
    ../../modules/wofi.nix
    ../../modules/firefox.nix
    ../../modules/helium.nix
    ../../modules/stylix.nix
    ../../modules/fish.nix
    ../../modules/git.nix
    ../../modules/ghostty.nix
    ../../modules/zed.nix
    ../../modules/noctalia.nix
  ];

  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  networking = {
    hostName = "raidorev";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    nixfmt
    nixd
    qt6.qtdeclarative
  ];

  system.stateVersion = "25.11";
}
