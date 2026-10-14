{ __findFile, ... }:
{
  den.aspects.hosts.desktop = {
    includes = [
      <hosts/base>
      <bluetooth>
      <pipewire>
      <power>
      <wayland>
    ];

    nixos = { pkgs, ... }: {
      boot = {
        loader.limine.resolution = "2560x1440";
        plymouth.enable = true;
      };
      environment.systemPackages = [ pkgs.trayscale ];
    };

    # Every user on a desktop host gets the desktop session and apps.
    provides.to-users = {
      includes = [
        <ghostty>
        <firefox>
        <zed>
        <stylix>
        <niri>
        <umbriel>
        <noctalia>
        <helium>
        <llms>
        <vesktop>
        <kenku-fm>
        <jetbrains>
        <libvirt>
        <samba>

        <thunar>
        <zathura>
        <qbittorrent>
        <flatpak>

        <media>
        <obsidian>
        <thunderbird>

        <gaming>
        <steam>

        <spotify>

        <plumsail>
      ];

      homeManager = { pkgs, ... }: {
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
  };
}
