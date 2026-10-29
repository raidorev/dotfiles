let
  domain = "money.raidorev.tech";
in
{
  den.aspects.firefly-iii = {
    nixos = { config, lib, pkgs, ... }: {
      sops.secrets."firefly-iii/app-key" = {
        sopsFile = ../sops/icewind.yaml;
        owner = config.services.firefly-iii.user;
      };

      # The module hands settings to Firefly only through Laravel's config
      # cache, so Firefly's own "clear cache" (/flush) leaves PHP-FPM without
      # APP_KEY and the database settings (MissingAppKeyException, 500s).
      # Give PHP-FPM the same values as environment variables as well.
      sops.templates."firefly-iii.env" = {
        content = lib.concatLines (
          lib.mapAttrsToList (n: v: "${n}=${toString v}") (
            lib.filterAttrs (
              n: v: v != null && !lib.hasSuffix "_FILE" n
            ) config.services.firefly-iii.settings
          )
          ++ [ "APP_KEY=${config.sops.placeholder."firefly-iii/app-key"}" ]
        );
        restartUnits = [ "phpfpm-firefly-iii.service" ];
      };
      systemd.services.phpfpm-firefly-iii.serviceConfig.EnvironmentFile =
        config.sops.templates."firefly-iii.env".path;

      services.firefly-iii = {
        enable = true;
        enableNginx = true;
        virtualHost = domain;
        # PHP-FPM drops environment variables by default; keep the ones above.
        poolConfig.clear_env = "no";
        settings = {
          APP_KEY_FILE = config.sops.secrets."firefly-iii/app-key".path;
          APP_URL = "https://${domain}";
          TZ = config.time.timeZone;
        };
      };

      services.nginx.virtualHosts.${domain} = {
        forceSSL = true;
        enableACME = true;
      };

      security.acme = {
        acceptTerms = true;
        defaults.email = "fox@raidorev.tech";
      };

      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
    };
  };
}
