{
  den.aspects.tailscale = { host, ... }: {
    nixos = { config, lib, ... }: {
      services.tailscale.enable = true;
      # Where dnsmasq is the local resolver, keep Tailscale out of resolvconf (it
      # registers as the exclusive upstream, hiding e.g. VPN DNS from dnsmasq) and
      # forward MagicDNS names to it instead.
      services.tailscale.extraSetFlags = lib.mkIf config.services.dnsmasq.enable [
        "--accept-dns=false"
      ];
      services.dnsmasq.settings.server = lib.mkIf config.services.dnsmasq.enable [
        "/ts.net/100.100.100.100"
      ];
      networking.nftables.enable = true;
      networking.firewall = {
        enable = true;
        trustedInterfaces = [ config.services.tailscale.interfaceName ];
        allowedUDPPorts = [ config.services.tailscale.port ];
      };
      systemd.services.tailscaled.serviceConfig.Environment = [
        "TS_DEBUG_FIREWALL_MODE=nftables"
      ];
      systemd.network.wait-online.enable = false;
      boot.initrd.systemd.network.wait-online.enable = false;
    };
  };
}
