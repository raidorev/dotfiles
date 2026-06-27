{
  den.aspects.boot = { host }: {
    nixos = { pkgs, ... }: {
      boot = {
        loader = {
          limine.enable = true;
          efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxPackages_latest;
      };
    };
  };
}
