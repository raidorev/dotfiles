{ __findFile, ... }:
{
  den.aspects.hosts.server = {
    includes = [ <hosts/base> ];

    nixos = {
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = false;
          KbdInteractiveAuthentication = false;
          PermitRootLogin = "no";
        };
      };
    };
  };
}
