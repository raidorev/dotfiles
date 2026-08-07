{
  den.aspects.nemo = {
    nixos.services.udisks2.enable = true;

    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.nemo-with-extensions ];

      services.udiskie = {
        enable = true;
        settings = {
          program_options = {
            file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
          };
        };
      };

      xdg.desktopEntries.nemo = {
        name = "Nemo";
        exec = "${pkgs.nemo-with-extensions}/bin/nemo";
      };

      xdg.mimeApps.defaultApplications = {
        "inode/directory" = [ "nemo.desktop" ];
        "application/x-gnome-saved-search" = [ "nemo.desktop" ];
      };
    };
  };
}
