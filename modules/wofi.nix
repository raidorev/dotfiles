{ den, ... }:
{
  den.aspects.wofi = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.wofi ];
    };
  };
}
