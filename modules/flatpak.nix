{ inputs, ... }:
{
  flake-file.inputs.nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

  den.aspects.flatpak = {
    nixos.services.flatpak.enable = true;

    homeManager = {
      imports = [ inputs.nix-flatpak.homeManagerModules.nix-flatpak ];

      services.flatpak = {
        packages = [ "com.microsoft.AzureStorageExplorer" ];

        # TODO: A better way?
        overrides."com.microsoft.AzureStorageExplorer".Environment.EXTRA_ARGS = "--ozone-platform=wayland";

        update.auto = {
          enable = true;
          onCalendar = "weekly";
        };
      };
    };
  };
}
