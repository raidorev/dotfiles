let
  # MCP servers live at <name>.mcp.raidorev.tech (wildcard DNS *.mcp -> icewind).
  domain = "firefly.mcp.raidorev.tech";
  port = 3000;
  # Public OAuth client in Firefly (Options -> Remote access and tokens,
  # "Keep a secret" unchecked, redirect https://firefly.mcp.raidorev.tech/oauth/callback).
  oauthClientId = "01a140ba-a734-72c5-9157-20797f434f63";
in
{
  # https://github.com/daften/fireflyiii-mcp: MCP clients log in through Firefly's
  # own OAuth, so the server holds no Firefly credentials.
  den.aspects.firefly-mcp = {
    nixos = {
      virtualisation.oci-containers.containers.firefly-mcp = {
        image = "ghcr.io/daften/fireflyiii-mcp:0.5.3";
        ports = [ "127.0.0.1:${toString port}:3000" ];
        environment = {
          FIREFLY_URL = "https://money.raidorev.tech";
          FIREFLY_OAUTH_CLIENT_ID = oauthClientId;
          # Must match the URL entered in the MCP client exactly (no path).
          MCP_BASE_URL = "https://${domain}";
        };
      };

      services.nginx.virtualHosts.${domain} = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString port}";
          recommendedProxySettings = true;
          # StreamableHTTP responses are streamed.
          extraConfig = ''
            proxy_buffering off;
            proxy_read_timeout 1h;
          '';
        };
      };
    };
  };
}
