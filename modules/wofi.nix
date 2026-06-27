{
  den.aspects.wofi = { user, ... }: {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.wofi ];
    };
  };
}
