{ __findFile, inputs, ... }:
{
  flake-file.inputs.spicetify-nix.url = "github:Gerg-L/spicetify-nix";

  den.aspects.spotify = {
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

    homeManager = {
      imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];
      programs.spicetify.enable = true;
    };
  };
}
