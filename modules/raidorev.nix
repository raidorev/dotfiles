{ __findFile, ... }:
{
  den.aspects.raidorev = {
    includes = [
      <den/define-user>
      <den/primary-user>
      (<den/user-shell> "fish")

      <git>
      <ssh>
      <ghostty>
      <firefox>
      <zed>
      <stylix>
      <niri>
      <noctalia>
      <helium>
      <fastfetch>
      <vesktop>
      <kenku-fm>
      <jetbrains>
      <libvirt>
      <samba>

      <direnv>
      <nix-tools>
      <thunar>
      <rclone>
      <zathura>
      <qbittorrent>
      <superfile>

      <steam>

      <spotify>

      <plumsail>

      # Shame on you, unfree software that I still use for some reason
      (<den/unfree> [
        "claude-code"
        "obsidian"
        "osu-lazer-bin"
      ])
    ];

    user.extraGroups = [ "input" ];

    homeManager = { pkgs, ... }: {
      targets.genericLinux.nixGL.vulkan.enable = true;

      # The handlers themselves live with the app that provides them.
      xdg.mimeApps.enable = true;

      home = {
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
        };
        packages = with pkgs; [
          eza
          ripgrep
          fd
          bat
          jq
          htop
          telegram-desktop
          prismlauncher

          kooha

          claude-code
          obsidian
          kitty
          calibre

          tuxedo

          vlc

          lazyjournal

          unetbootin

          super-productivity

          parabolic
          osu-lazer-bin
        ];
      };
    };
  };
}
