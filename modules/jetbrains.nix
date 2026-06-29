{ __findFile, ... }:
{
  den.aspects.jetbrains = {
    includes = [
      (<den/unfree> [
        "webstorm"
        "rider"
      ])
    ];

    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        jetbrains.webstorm
        jetbrains.rider
      ];
    };
  };
}
