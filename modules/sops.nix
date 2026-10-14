{ inputs, ... }:
{
  flake-file.inputs.sops-nix = {
    url = "github:Mic92/sops-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.sops = { user, ... }: {
    nixos = { config, ... }: {
      imports = [ inputs.sops-nix.nixosModules.sops ];
      sops = {
        age.sshKeyPaths = [ "${config.users.users.${user.userName}.home}/.ssh/id_ed25519" ];
        gnupg.sshKeyPaths = [ ];
      };
    };

    homeManager = { config, pkgs, ... }: {
      home.packages = [ pkgs.sops ];
      home.sessionVariables.SOPS_AGE_KEY_CMD = "${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i ${config.home.homeDirectory}/.ssh/id_ed25519";
    };
  };
}
