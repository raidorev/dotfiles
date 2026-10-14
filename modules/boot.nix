{
  den.aspects.boot = {
    nixos = { pkgs, ... }: {
      boot = {
        loader = {
          limine = {
            enable = true;
            maxGenerations = 8;
          };
          efi.canTouchEfiVariables = true;
        };

        kernelPackages = pkgs.linuxPackages_latest;
      };
    };
  };
}
