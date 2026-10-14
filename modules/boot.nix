{
  den.aspects.boot = {
    nixos = { pkgs, ... }: {
      boot = {
        loader.limine = {
          enable = true;
          maxGenerations = 8;
        };

        kernelPackages = pkgs.linuxPackages_latest;
      };
    };
  };
}
