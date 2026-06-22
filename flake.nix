{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia/legacy-v4";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      home-manager,
      nix-index-database,
      stylix,
      ...
    }@inputs:
    let
      mkHost =
        host:
        let
          hostPath = ./hosts + "/${host}";
          fromHost = file: hostPath + "/${file}.nix";
          opts = import (fromHost "options");
        in
        inputs.nixpkgs.lib.nixosSystem {
          system = opts.system;

          specialArgs = { inherit inputs opts; };

          modules = [
            stylix.nixosModules.stylix
            nix-index-database.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = { inherit inputs opts; };
              home-manager.users.${opts.user.name} = import (fromHost "home");
            }

            ./modules/users.nix

            (fromHost "configuration")
          ];
        };
    in
    {
      nixosConfigurations = {
        nixos = mkHost "pc";
        laptop = mkHost "laptop";
      };
    };
}
