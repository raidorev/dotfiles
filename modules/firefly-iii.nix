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
        # nixpkgs bumped firefly-iii to 6.7.7 but kept the old releaseTarball
        # hash, so Nix reuses the 6.6.6 tarball: stale resources/lang and no
        # public/v3/i18n, and the v3 frontend shows raw keys
        # (`firefly.intro_next_label`). Drop once nixpkgs fixes the hash.
        package = pkgs.firefly-iii.overrideAttrs (
          finalAttrs: prev: {
            passthru = prev.passthru // {
              releaseTarball = pkgs.fetchzip {
                url = "https://github.com/firefly-iii/firefly-iii/releases/download/v${finalAttrs.version}/FireflyIII-v${finalAttrs.version}.tar.gz";
                stripRoot = false;
                hash = "sha256-kI0vhWpOTYjqoAcPws8N049StWhKjehoeOWiEz3RFPM=";
              };
            };
            postInstall = prev.postInstall + ''
              # nixpkgs copies resources/lang from the release tarball but misses the v3 frontend translations
              cp ${finalAttrs.passthru.releaseTarball}/public/v3/i18n/*.json $out/public/v3/i18n/
            '';
          }
        );
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
