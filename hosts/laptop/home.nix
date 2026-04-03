{ pkgs, ... }:

{
  imports = [ ];

  targets.genericLinux.nixGL.vulkan.enable = true;

  xdg.desktopEntries.nemo = {
    name = "Nemo";
    exec = "${pkgs.nemo-with-extensions}/bin/nemo";
  };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "nemo.desktop" ];
      "application/x-gnome-saved-search" = [ "nemo.desktop" ];
    };
  };

  home = {
    username = "raidorev";
    homeDirectory = "/home/raidorev";
    stateVersion = "25.11";
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      QML_IMPORT_PATH = "${pkgs.qt6.qtdeclarative}/lib/qt6/qml";
      QML2_IMPORT_PATH = "${pkgs.qt6.qtdeclarative}/lib/qt6/qml";
    };
    packages = with pkgs; [
      eza
      ripgrep
      fd
      bat
      jq
      htop
      telegram-desktop
      discord
      mpv
      nemo-with-extensions
    ];

  };
}
