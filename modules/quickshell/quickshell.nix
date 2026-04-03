{ ... }:

{
  qt.enable = true;

  home-manager.users.raidorev.programs.quickshell = {
    enable = true;
    configs = {
      default = ./default;
    };
  };
}
