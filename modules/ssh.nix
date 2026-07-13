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
          "vs-ssh.visualstudio.com" = {
            identityFile = "~/.ssh/id_rsa_plumsail";
            user = "plumsail";
          };
          "ssh.dev.azure.com" = {
            identityFile = "~/.ssh/id_rsa_plumsail";
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
