{ inputs, ... }:
{
  flake-file.inputs.helium = {
    url = "github:schembriaiden/helium-browser-nix-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.helium = { user, ... }: {
    homeManager =
      { pkgs, config, ... }:
      let
        helium = inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default;
      in
      {
        home.packages = [ helium ];

        xdg.desktopEntries.helium-dnd = {
          name = "Helium (FoundryVTT)";
          exec = "${helium}/bin/helium --disable-background-timer-throttling --disable-backgrounding-occluded-windows --disable-renderer-backgrounding --user-data-dir=${config.xdg.configHome}/helium-dnd %U";
          icon = "helium";
          terminal = false;
          categories = [
            "Network"
            "WebBrowser"
          ];
        };
      };
  };
}
