{
  den.aspects.rclone = {
    nixos = {
      programs.fuse.enable = true;
      programs.fuse.userAllowOther = true;
    };

    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.rclone ];

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
    };
  };
}
