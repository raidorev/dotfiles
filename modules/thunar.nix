{
  den.aspects.thunar = {
    nixos =
      { pkgs, ... }:
      {
        services.udisks2.enable = true;
        # Trash, remote mounts, thumbnails.
        services.gvfs.enable = true;
        services.tumbler.enable = true;

        programs.thunar = {
          enable = true;
          plugins = with pkgs; [
            thunar-archive-plugin
            thunar-volman
          ];
        };
      };

    homeManager = {
      services.udiskie = {
        enable = true;
        settings = {
          program_options = {
            file_manager = "thunar";
          };
        };
      };

      xdg.mimeApps.defaultApplications = {
        "inode/directory" = [ "thunar.desktop" ];
      };
    };
  };
}
