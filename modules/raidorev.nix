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
      <umbriel>
      <noctalia>
      <helium>
      <fastfetch>
      <llms>
      <vesktop>
      <kenku-fm>
      <jetbrains>
      <libvirt>
      <samba>

      <cli-tools>
      <direnv>
      <nix-tools>
      <sops>
      <thunar>
      # <rclone>
      <zathura>
      <qbittorrent>
      <superfile>
      <flatpak>

      <media>
      <obsidian>
      <thunderbird>

      <gaming>
      <steam>

      <spotify>

      <plumsail>
    ];

    user.extraGroups = [ "input" ];

    homeManager = { pkgs, ... }: {
      targets.genericLinux.nixGL.vulkan.enable = true;

      # The handlers themselves live with the app that provides them.
      xdg.mimeApps.enable = true;

      home.packages = with pkgs; [
        telegram-desktop
        kitty
        calibre
        unetbootin
        super-productivity
      ];
    };
  };
}
