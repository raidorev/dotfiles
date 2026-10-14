{ __findFile, ... }:
{
  den.aspects.hosts.server = {
    includes = [ <hosts/base> ];

    nixos = {
      security.sudo.wheelNeedsPassword = false;
      nix.settings.trusted-users = [ "@wheel" ];

      # No personal SSH key here; sops decrypts with the host key
      # (its age recipient is listed in .sops.yaml).
      sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

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
