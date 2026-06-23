{ pkgs, inputs, ... }:
{
  # install package
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    # ... maybe other stuff
  ];

  home-manager.users.raidorev = {
    home.file.".face".source = ../punk-cat;
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      settings = {
        location = {
          name = "St Petersburg";
        };
      };
    };
  };
}
