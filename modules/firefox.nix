{ ... }:
{
  programs.firefox.enable = true;

  home-manager.users.raidorev.programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      isDefault = true;
      name = "Default";
    };
  };
}
