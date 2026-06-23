{ den, ... }:
{
  den.aspects.ghostty = {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.ghostty ];
      programs.ghostty = {
        enable = true;
        enableFishIntegration = true;
        systemd.enable = true;
      };
    };
  };
}
