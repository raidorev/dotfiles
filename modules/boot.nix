{
  den.aspects.boot = { host }: {
    nixos = { pkgs, ... }: {
      boot = {
        loader = {
          limine = {
            enable = true;
            resolution = "2560x1440";
            maxGenerations = 8;
          };
          efi.canTouchEfiVariables = true;
        };
        kernelParams = [
          "nvidia_drm.modeset=1"
          "nvidia_drm.fbdev=1"
          "initcall_blacklist=simpledrm_platform_driver_init"
        ];

        # TODO: https://github.com/NixOS/nixpkgs/issues/554041
        kernelPackages =
          if host.ddcMonitor then
            let
              patch =
                p:
                p.extend (
                  self: super: {
                    ddcci-driver = super.ddcci-driver.overrideAttrs (
                      fin: prev: {
                        src = pkgs.fetchFromGitLab {
                          # https://gitlab.com/dkadioglu/ddcci-driver-linux/-/tree/replace-strncpy-strscpy
                          owner = "dkadioglu";
                          repo = "ddcci-driver-linux";
                          rev = "db5d6b87b2c85ff91a4470c50a4da99534d9917c";
                          hash = "sha256-l8e9J2ZVtH5rJ47toi+A1K0mneQu1W/ik2cQHz7QRwY=";
                        };
                      }
                    );
                  }
                );
            in
            patch pkgs.linuxPackages_latest
          else
            pkgs.linuxPackages_latest;

        plymouth.enable = true;
      };
    };
  };
}
