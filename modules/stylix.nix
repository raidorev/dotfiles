{ inputs, ... }:
{
  flake-file.inputs.stylix = {
    url = "github:nix-community/stylix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.stylix = { host, user, ... }: {
    nixos = { pkgs, ... }: {
      imports = [ inputs.stylix.nixosModules.stylix ];

      nix.settings = {
        extra-substituters = [ "https://catppuccin.cachix.org" ];
        extra-trusted-public-keys = [
          "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
        ];
      };

      stylix = {
        enable = true;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        image = ../wallpapers/cabin-2.jpg;

        cursor = {
          package = pkgs.catppuccin-cursors.mochaRosewater;
          name = "catppuccin-mocha-rosewater-cursors";
          size = 24;
        };

        icons = {
          enable = true;
          package = pkgs.catppuccin-papirus-folders.override {
            flavor = "mocha";
            accent = "rosewater";
          };
          dark = "Papirus-Dark";
          light = "Papirus-Light";
        };

        fonts = {
          serif = {
            package = pkgs.noto-fonts;
            name = "Noto Serif";
          };
          sansSerif = {
            package = pkgs.noto-fonts;
            name = "Noto Sans";
          };
          monospace = {
            package = pkgs.jetbrains-mono;
            name = "JetBrains Mono";
          };
          emoji = {
            package = pkgs.noto-fonts-color-emoji;
            name = "Noto Color Emoji";
          };
        };
      };
    };

    homeManager.stylix.targets.firefox.profileNames = [ "default" ];
  };
}
