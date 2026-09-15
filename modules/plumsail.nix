{ __findFile, ... }:
{
  den.aspects.plumsail = {
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
        settings = {
          "vs-ssh.visualstudio.com" = {
            IdentityFile = "~/.ssh/id_rsa_plumsail";
            User = "plumsail";
          };
          "ssh.dev.azure.com" = {
            IdentityFile = "~/.ssh/id_rsa_plumsail";
            User = "git";
          };
        };
      };
    };
  };
}
