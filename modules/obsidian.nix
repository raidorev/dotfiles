{ __findFile, ... }:
{
  den.aspects.obsidian = {
    includes = [
      # Shame on you, unfree software that I still use for some reason
      (<den/unfree> [ "obsidian" ])
    ];

    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.obsidian ];
    };
  };
}
