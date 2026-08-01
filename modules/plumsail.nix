{ __findFile, ... }:
{
  den.aspects.plumsail = { host, ... }: {
    includes = [
      (<den/unfree> [ "slack" ])
      <secureframe>
    ];

    nixos = {
      networking.hosts = {
        "172.16.10.113" = [
          "forms.plumsail.com"
          "auth.plumsail.com"
          "account.plumsail.com"
          "plumsail.io"
          "api.plumsail.com"
          "au-forms.plumsail.com"
          "au-account.plumsail.com"
          "au-plumsail.com"
          "admin.plumsail.io"
          "a-titov.plumsail.io"
        ];
      };
    };

    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.slack ];

      programs.zoxide.enable = true;

      programs.ssh = {
        enable = true;
        matchBlocks = {
          "vs-ssh.visualstudio.com" = {
            identityFile = "~/.ssh/id_rsa_plumsail";
            user = "plumsail";
          };
          "ssh.dev.azure.com" = {
            identityFile = "~/.ssh/id_rsa_plumsail";
            user = "git";
          };
        };
      };
    };
  };
}
