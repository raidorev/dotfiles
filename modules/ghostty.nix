{
  den.aspects.ghostty = { user, ... }: {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.ghostty ];
      programs.ghostty = {
        enable = true;
        enableFishIntegration = true;
        systemd.enable = true;
        settings = {
          shell-integration-features = "ssh-env,ssh-terminfo";
        };
      };
    };
  };
}
