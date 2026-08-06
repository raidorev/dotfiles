{
  den.aspects.secureframe = {
    nixos = { pkgs, ... }:
    let
      # Vendor package as downloaded from Secureframe (gitignored, not built by Nix).
      vendorDeb = "/etc/nixos/vendor/secureframe-agent.deb";
      # ORBIT_ENROLL_SECRET + ORBIT_SPECIFIED_IDENTIFIER (gitignored, root-only, not committed).
      secretEnvFile = "/etc/nixos/secrets/secureframe-orbit.env";
      # The vendor package bakes in an *absolute* symlink
      # (bin/orbit/orbit -> /opt/orbit/bin/orbit/linux/stable/orbit), so the state dir
      # has to actually be /opt/orbit rather than the more idiomatic /var/lib/orbit.
      stateDir = "/opt/orbit";

      # osqueryd is a dynamically-linked glibc binary (needs /lib64/ld-linux-x86-64.so.2);
      # orbit and fleet-desktop are static Go binaries and would run fine unwrapped, but
      # wrapping the top-level `orbit` process is enough: child processes it execs (like
      # osqueryd, including ones fetched later by the auto-updater) inherit the same
      # bubblewrap mount namespace, so they see the FHS shim too.
      orbitStart = pkgs.writeShellScript "orbit-start" ''
        exec ${pkgs.steam-run}/bin/steam-run ${stateDir}/bin/orbit/orbit -- \
          --host_identifier specified \
          --specified_identifier "$ORBIT_SPECIFIED_IDENTIFIER"
      '';
    in
    {
      systemd.tmpfiles.rules = [
        "d ${stateDir} 0700 root root - -"
      ];

      # One-time seed: extract the vendor package's /opt/orbit tree (binaries + TUF
      # metadata + certs — no secrets) into the writable state dir. Guarded by a sentinel
      # file so it never re-runs and clobbers binaries orbit's own auto-updater has since
      # downloaded.
      systemd.services.orbit-seed = {
        description = "Seed Secureframe orbit agent files from vendor package";
        unitConfig.ConditionPathExists = "!${stateDir}/.seeded";
        serviceConfig.Type = "oneshot";
        path = [ pkgs.dpkg pkgs.coreutils ];
        script = ''
          set -e
          tmpdir=$(mktemp -d)
          trap 'rm -rf "$tmpdir"' EXIT
          dpkg-deb -x ${vendorDeb} "$tmpdir"
          cp -a "$tmpdir"/opt/orbit/. ${stateDir}/
          touch ${stateDir}/.seeded
        '';
      };

      systemd.services.orbit = {
        description = "Secureframe device agent (Fleet orbit + osquery)";
        after = [ "network-online.target" "orbit-seed.service" ];
        wants = [ "network-online.target" ];
        requires = [ "orbit-seed.service" ];
        wantedBy = [ "multi-user.target" ];
        startLimitIntervalSec = 0;

        environment = {
          ORBIT_ROOT_DIR = stateDir;
          ORBIT_FLEET_URL = "https://agent.secureframe.com:443";
          ORBIT_UPDATE_URL = "https://updates.fleetdm.com";
          ORBIT_ORBIT_CHANNEL = "stable";
          ORBIT_OSQUERYD_CHANNEL = "stable";
          ORBIT_UPDATE_INTERVAL = "15m0s";
          ORBIT_DESKTOP_CHANNEL = "stable";
        };

        serviceConfig = {
          Type = "simple";
          EnvironmentFile = secretEnvFile;
          ExecStart = "${orbitStart}";
          Restart = "always";
          RestartSec = 1;
          KillMode = "control-group";
          KillSignal = "SIGTERM";
          CPUQuota = "20%";
        };
      };
    };
  };
}
