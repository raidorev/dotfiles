{ __findFile, ... }:
{
  den.aspects.gaming = {
    includes = [
      (<den/unfree> [ "osu-lazer-bin" ])
    ];

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        prismlauncher
        osu-lazer-bin
      ];
    };
  };
}
