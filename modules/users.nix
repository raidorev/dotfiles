{ pkgs, ... }:
{
  users.users.raidorev = {
    isNormalUser = true;
    description = "Alexander";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
    ];
    shell = pkgs.fish;
  };

  programs.fish.enable = true;
}
