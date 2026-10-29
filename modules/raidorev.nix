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

    nixos = {
      programs.starship.enable = true;
    };

    homeManager = {
      targets.genericLinux.nixGL.vulkan.enable = true;
      programs.starship = {
        enable = true;
        settings = {
          add_newline = false;
          format = "$directory\${custom.branch}$git_status$nix_shell$fill$cmd_duration$line_break$character";

          custom.branch = {
            command = "git branch --show-current | sed -e 's|^feature/|✨ |' -e 's|^bugfix/|🐛 |' -e 's|^hotfix/|🔥 |'";
            when = "git rev-parse --is-inside-work-tree";
            format = "[$output]($style) ";
            style = "bold purple";
          };

          git_status.format = "([$all_status$ahead_behind]($style) )";
          nix_shell.disabled = true;
        };
      };
    };
  };
}
