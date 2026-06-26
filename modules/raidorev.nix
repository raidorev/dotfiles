{ den, __findFile, ... }:
{
  den.aspects.raidorev = { user, host, ... }: {
    includes = [
      <den/define-user>
      <den/primary-user>
      (<den/user-shell> "fish")

      <git>
      <ghostty>
      <wofi>
      <firefox>
      <zed>
      <stylix>
      <niri>
      <noctalia>
      <helium>

      # Shame on you, unfree software that I still use for some reason
      (den.provides.unfree [
        "discord"
        "spotify"
        "claude-code"
      ])
    ];

    nixos.users.users.raidorev.extraGroups = [
      "networkmanager"
      "input"
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
          nil
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
