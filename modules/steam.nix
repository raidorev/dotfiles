{ __findFile, ... }:
{
  den.aspects.steam = {
    includes = [
      (<den/unfree> [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
      ])
    ];

    nixos = {
      programs.steam.enable = true;
    };
  };
}
