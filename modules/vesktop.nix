{
  den.aspects.vesktop = { user, ... }: {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.vesktop ];
    };
  };
}
