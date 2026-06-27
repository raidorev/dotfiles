{
  den.aspects.fastfetch.homeManager = { pkgs, config, ... }: {
    home.packages = [ pkgs.fastfetch ];
    home.file."${config.xdg.configHome}/fastfetch" = {
      source = ./raw/fastfetch;
      recursive = true;
    };
  };
}
