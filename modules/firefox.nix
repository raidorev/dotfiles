{ den, ... }:
{
  den.aspects.firefox = {
    nixos = { ... }: {
      programs.firefox.enable = true;
    };
    homeManager = { ... }: {
      programs.firefox = {
        enable = true;
        profiles.default = {
          id = 0;
          isDefault = true;
          name = "Default";
        };
      };
    };
  };
}
