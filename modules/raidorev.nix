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
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMeWxlo7NgypRpXx5mjOgESmdfquy0ofICN6i29WTcf0"
      ];
    };

    homeManager = {
      targets.genericLinux.nixGL.vulkan.enable = true;
    };
  };
}
