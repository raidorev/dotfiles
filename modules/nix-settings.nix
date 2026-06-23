{ inputs, ... }:
{
  flake-file.inputs.nix-index-database = {
    url = "github:nix-community/nix-index-database";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.nix-settings = { host, user, ... }: {
    nixos = {
      imports = [ inputs.nix-index-database.nixosModules.default ];

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        substituters = [ "https://nix-community.cachix.org" ];
        trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
      };
      programs.nh = {
        enable = true;
        clean.enable = true;
        clean.extraArgs = "--keep-since 4d --keep 3";
        flake = "/etc/nixos";
      };
      programs.nix-index-database.comma.enable = true;
    };

    homeManager = {
      programs.nix-index.enable = true;
    };
  };
}
