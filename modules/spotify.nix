{ __findFile, ... }:
{
  den.aspects.raidorev = {
    includes = [
      # Shame on you, unfree software that I still use for some reason
      (<den/unfree> [ "spotify" ])
    ];

    nixos = {
      networking.firewall = {
        # Spotify discovery and Spotify connect
        allowedTCPPorts = [ 57621 ];
        allowedUDPPorts = [ 5353 ];
      };
    };

    homeManager = { pkgs, ... }: {
      services.spotifyd.enable = true;

      home = {
        packages = with pkgs; [ spotify ];
      };
    };
  };
}
