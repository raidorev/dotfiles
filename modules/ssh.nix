{
  den.aspects.ssh = {
    homeManager = {
      programs.ssh = {
        enable = true;
        enableDefaultConfig = false;

        settings = {
          "github.com" = {
            IdentityFile = "~/.ssh/id_ed25519";
            User = "git";
          };
          "porygon.vitalya.me" = {
            IdentityFile = "~/.ssh/id_rsa";
            User = "sanyasuper2002";
          };
        };
      };
    };
  };
}
