{ den, ... }:
{
  den.aspects.jetbrains = {
    includes = [
      (den.provides.unfree [
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
