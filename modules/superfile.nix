{
  den.aspects.superfile = {
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.superfile ];
      };
  };
}
