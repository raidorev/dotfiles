{
  den.aspects.zathura = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.zathura ];

      xdg.mimeApps.defaultApplications."application/pdf" = "org.pwmt.zathura.desktop";
    };
  };
}
