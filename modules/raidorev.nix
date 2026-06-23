{ den, ... }:
{
  den.aspects.raidorev = {
    includes = [
      den.batteries.define-user
      den.batteries.primary-user
      (den.batteries.user-shell "fish")

      # Shame on you, unfree software that I still use for some reason
      (den.provides.unfree [
        "discord"
        "spotify"
        "claude-code"
      ])
    ];

    homeManager = { pkgs, ... }: {
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
          nemo-with-extensions

          nixfmt
          nixd
          qt6.qtdeclarative
          kooha

          discord
          spotify
          claude-code
        ];
      };
    };
  };
}
