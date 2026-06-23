{ den, ... }:
{
  den.aspects.git = {
    nixos = { ... }: {
      programs.git.enable = true;
    };
    homeManager = { ... }: {
      programs.git = {
        enable = true;
        settings = {
          user = {
            name = "Alexander Titov";
            email = "fox@raidorev.tech";
          };
          init.defaultBranch = "main";
        };
      };
    };
  };
}
