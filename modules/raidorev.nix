{ den, __findFile, ... }:
{
  den.aspects.raidorev = { host, ... }: {
    includes = [
      <den/define-user>
      <den/primary-user>
      (<den/user-shell> "fish")

      <git>
      <ssh>
      <ghostty>
      <wofi>
      <firefox>
      <zed>
      <stylix>
      <niri>
      <noctalia>
      <helium>
      <fastfetch>
      <vesktop>
      <jetbrains>

      <steam>
      <minecraft>

      # Shame on you, unfree software that I still use for some reason
      (<den/unfree> [
        "claude-code"
        "obsidian"
      ])
    ];
    nixos = {
      users.users.raidorev.extraGroups = [
        "networkmanager"
        "input"
      ];
      networking.firewall.enable = false;
      # networking.firewall.allowedTCPPorts = [ 57621 ];
      # networking.firewall.allowedUDPPorts = [ 5353 ];

      services.calibre-server.enable = true;
      services.calibre-server.libraries = [
        "/home/raidorev/Calibre Library"
      ];

      programs.fuse.enable = true;
      programs.fuse.userAllowOther = true;
    };

    homeManager = { pkgs, ... }: {
      targets.genericLinux.nixGL.vulkan.enable = true;

      xdg.desktopEntries.nemo = {
        name = "Nemo";
        exec = "${pkgs.nemo-with-extensions}/bin/nemo";
      };
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "inode/directory" = [ "nemo.desktop" ];
          "application/x-gnome-saved-search" = [ "nemo.desktop" ];

          "text/html" = "helium.desktop";
          "x-scheme-handler/http" = "helium.desktop";
          "x-scheme-handler/https" = "helium.desktop";
          "x-scheme-handler/about" = "helium.desktop";
          "x-scheme-handler/unknown" = "helium.desktop";
        };
      };

      services.spotifyd.enable = true;

      systemd.user.services.rclone-onedrive = {
        Unit = {
          Description = "rclone mount for OneDrive";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };
        Service = {
          Type = "notify";
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/OneDrive";
          ExecStart = "${pkgs.rclone}/bin/rclone mount OneDrive: %h/OneDrive --vfs-cache-mode writes --allow-other";
          ExecStop = "${pkgs.fuse}/bin/fusermount -u %h/OneDrive";
          Restart = "on-failure";
          RestartSec = 10;
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
      };

      home = {
        sessionVariables = {
          NIXOS_OZONE_WL = "1";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
        };
        packages = with pkgs; [
          eza
          ripgrep
          fd
          bat
          jq
          htop
          telegram-desktop
          nemo-with-extensions

          nixfmt
          nixd
          nil
          kooha

          claude-code
          obsidian
          kitty
          calibre

          rclone
        ];
      };
    };
  };
}
