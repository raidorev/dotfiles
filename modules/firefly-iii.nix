let
  domain = "money.raidorev.tech";
in
{
  den.aspects.firefly-iii = {
    nixos = { config, ... }: {
      sops.secrets."firefly-iii/app-key" = {
        sopsFile = ../sops/icewind.yaml;
        owner = config.services.firefly-iii.user;
      };

      services.firefly-iii = {
        enable = true;
        enableNginx = true;
        virtualHost = domain;
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
