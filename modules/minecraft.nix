{ inputs, ... }:
{
  flake-file.inputs.freesmlauncher = {
    url = "github:FreesmTeam/FreesmLauncher";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.minecraft = {
    homeManager = { pkgs, ... }: {
      home.packages = [
        inputs.freesmlauncher.packages.${pkgs.stdenv.hostPlatform.system}.freesmlauncher
      ];
    };
  };
}
