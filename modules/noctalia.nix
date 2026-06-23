{ inputs, den, ... }:
{
  flake-file.inputs.noctalia = {
    url = "github:noctalia-dev/noctalia/legacy-v4";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.noctalia = {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };

    homeManager = { ... }: {
      imports = [ inputs.noctalia.homeModules.default ];

      home.file.".face".source = ../punk-cat;

      programs.noctalia-shell = {
        enable = true;
        settings.location.name = "St Petersburg";
      };
    };
  };
}
