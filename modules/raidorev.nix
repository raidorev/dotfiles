{ __findFile, ... }:
{
  den.aspects.raidorev = {
    includes = [
      <den/define-user>
      <den/primary-user>
      (<den/user-shell> "fish")

      <git>
      <ssh>
      <fastfetch>

      <cli-tools>
      <direnv>
      <nix-tools>
      <sops>
      # <rclone>
      <superfile>
    ];

    user = {
      extraGroups = [ "input" ];
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBj0qBGWNXOCJCmEQf+mxyeeEdkndxs7dzk/I6DXTfJe raidorev@raidorev"
      ];
    };

    homeManager = {
      targets.genericLinux.nixGL.vulkan.enable = true;
    };
  };
}
