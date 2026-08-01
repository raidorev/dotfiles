{
  den.aspects.ssh = {
    homeManager = {
      programs.ssh = {
        enable = true;
        matchBlocks = {
          "github.com" = {
            identityFile = "~/.ssh/id_ed25519";
            user = "git";
          };
          "porygon.vitalya.me" = {
            identityFile = "~/.ssh/id_rsa";
            user = "sanyasuper2002";
          };
        };
      };
    };
  };
}
