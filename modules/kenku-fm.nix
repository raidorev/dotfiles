{ ... }:
{
  den.aspects.kenku-fm = {
    homeManager = { pkgs, ... }: {
      home.packages = [ (pkgs.callPackage ../pkgs/kenku-fm/package.nix { }) ];
    };
  };
}
