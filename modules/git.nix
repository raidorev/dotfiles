  {...}:
  {
  programs.git.enable = true;
  home-manager.users.raidorev.programs.git =  {
    enable = true;
    settings = {
      user = {
        name  = "Alexander Titov";
        email = "fox@raidorev.tech";
      };
      init.defaultBranch = "main";
    };
  };
  }
