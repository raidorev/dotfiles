{ __findFile, ... }:
let
  devHosts = {
    "172.16.10.113" = [
      "forms.plumsail.com"
      "auth.plumsail.com"
      "account.plumsail.com"
      "plumsail.io"
      "api.plumsail.com"
      "au-forms.plumsail.com"
      "au-account.plumsail.com"
      "au-plumsail.com"
      "admin.plumsail.io"
      "a-titov.plumsail.io"
    ];
  };

  stateDir = "/run/plumsail-dns";
  wgConnections = [ "plumsail-wg-internal" ];
in
{
  den.aspects.plumsail = {
    includes = [
      (<den/unfree> [ "slack" ])
      # <secureframe>
    ];

    nixos =
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        systemctl = "${config.systemd.package}/bin/systemctl";
        # Signal dnsmasq directly: a `systemctl reload` job would wait on this
        # unit's own stop job (After=dnsmasq) and deadlock. "-": dnsmasq may be down.
        reloadDnsmasq = "-${systemctl} kill --kill-whom=main --signal=SIGHUP dnsmasq.service";

        hostsFile = pkgs.writeText "plumsail-hosts" (
          lib.concatStrings (lib.mapAttrsToList (ip: names: "${ip} ${toString names}\n") devHosts)
        );

        serversFile = pkgs.writeText "plumsail-servers" (
          lib.concatMapStrings (name: "server=/${name}/\n") (lib.concatLists (lib.attrValues devHosts))
        );
      in
      {
        sops.secrets = lib.genAttrs [ "wg-internal/private_key" "wg-internal/psk" ] (_: {
          sopsFile = ../sops/plumsail.yaml;
        });

        sops.templates."plumsail-wg.env" = {
          content = ''
            WG_INTERNAL_PRIVATE_KEY=${config.sops.placeholder."wg-internal/private_key"}
            WG_INTERNAL_PSK=${config.sops.placeholder."wg-internal/psk"}
          '';
          restartUnits = [ "NetworkManager-ensure-profiles.service" ];
        };

        networking.networkmanager.ensureProfiles = {
          environmentFiles = [ config.sops.templates."plumsail-wg.env".path ];

          profiles.plumsail-wg-internal = {
            connection = {
              id = "plumsail-wg-internal";
              type = "wireguard";
              interface-name = "wg-plumsail";
              autoconnect = false;
            };
            wireguard = {
              private-key = "$WG_INTERNAL_PRIVATE_KEY";
              mtu = 1280;
            };
            "wireguard-peer.ARlxSNZDWynQaGOHauISp16Q+dEYbC9DeAyEqVBQtnQ=" = {
              endpoint = "firezone.plumsail.com:51820";
              preshared-key = "$WG_INTERNAL_PSK";
              preshared-key-flags = 0;
              allowed-ips = "172.16.10.0/24;172.16.16.0/24;1.1.1.1/32;8.8.8.8/32;";
              persistent-keepalive = 45;
            };
            ipv4 = {
              method = "manual";
              address1 = "10.3.2.246/32";
              dns = "172.16.16.1;172.16.16.5;172.16.16.4;";
            };
            ipv6 = {
              method = "manual";
              address1 = "fd00::3:2:de/128";
            };
          };
        };

        networking.networkmanager.dispatcherScripts = [
          {
            type = "basic";
            source = pkgs.writeShellScript "plumsail-dns-dispatcher" ''
              case " ${toString wgConnections} " in
                *" $CONNECTION_ID "*) ;;
                *) exit 0 ;;
              esac

              case "$2" in
                up) ${systemctl} start plumsail-dns.service ;;
                down) ${systemctl} stop plumsail-dns.service ;;
              esac
            '';
          }
        ];

        services.dnsmasq = {
          enable = true;
          settings = {
            listen-address = [
              "127.0.0.1"
              "::1"
            ];
            bind-interfaces = true;
            addn-hosts = "${stateDir}/hosts";
            servers-file = "${stateDir}/servers";
            strict-order = true;
          };
        };

        systemd.tmpfiles.rules = [
          "d ${stateDir} 0755 root root -"
          "f ${stateDir}/hosts 0644 root root -"
          "f ${stateDir}/servers 0644 root root -"
        ];

        systemd.services.plumsail-dns = {
          description = "Point Plumsail hosts to the dev environment";
          wants = [ "dnsmasq.service" ];
          after = [ "dnsmasq.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = [
              "${pkgs.coreutils}/bin/install -m644 ${hostsFile} ${stateDir}/hosts"
              "${pkgs.coreutils}/bin/install -m644 ${serversFile} ${stateDir}/servers"
              reloadDnsmasq
            ];
            ExecStop = [
              "${pkgs.coreutils}/bin/truncate -s0 ${stateDir}/hosts ${stateDir}/servers"
              reloadDnsmasq
            ];
          };
        };
      };

    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.slack ];

      programs.zoxide.enable = true;

      programs.ssh = {
        enable = true;
        settings = {
          "vs-ssh.visualstudio.com" = {
            IdentityFile = "~/.ssh/id_rsa_plumsail";
            User = "plumsail";
          };
          "ssh.dev.azure.com" = {
            IdentityFile = "~/.ssh/id_rsa_plumsail";
            User = "git";
          };
        };
      };
    };
  };
}
