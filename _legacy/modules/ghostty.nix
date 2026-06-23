{ pkgs, ... }:
{
  users.users.raidorev.packages = [
    pkgs.ghostty
  ];

  home-manager.users.raidorev.programs.ghostty = {
    enable = true;
    enableFishIntegration = true;
    systemd.enable = true;
    # settings = {
    # window-show-tab-bar = "never";
    # };
  };
}
