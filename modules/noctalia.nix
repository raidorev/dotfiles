{ inputs, ... }:
{
  flake-file.inputs.noctalia = {
    url = "github:noctalia-dev/noctalia/legacy-v4";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.noctalia = { host, user, ... }: {
    nixos = { pkgs, ... }: {
      environment.systemPackages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];

      nix.settings = {
        extra-substituters = [ "https://noctalia.cachix.org" ];
        extra-trusted-public-keys = [
          "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        ];
      };
    };

    homeManager = {
      imports = [ inputs.noctalia.homeModules.default ];

      home.file.".face".source = ../profile.png;

      programs.noctalia-shell = {
        enable = true;
        settings.location.name = "St Petersburg";
      };
    };
  };
}
