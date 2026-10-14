{
  den.aspects.wayland = {
    homeManager = { pkgs, ... }: {
      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };
      home.packages = with pkgs; [
        wl-clipboard
        wtype
      ];
    };
  };
}
