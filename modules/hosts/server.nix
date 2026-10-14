{ __findFile, ... }:
{
  den.aspects.hosts.server = {
    includes = [ <hosts/base> ];

    nixos = {
      security.sudo.wheelNeedsPassword = false;
      nix.settings.trusted-users = [ "@wheel" ];

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
