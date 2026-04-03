{ inputs, pkgs, ... }:
{
  home-manager.users.raidorev.home.packages = [
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
