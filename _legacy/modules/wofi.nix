{ pkgs, ... }:
{
  users.users.raidorev.packages = [
    pkgs.wofi
  ];
}
