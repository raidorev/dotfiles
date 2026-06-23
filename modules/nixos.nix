{ den, ... }:
{
  # host aspect
  den.aspects.nixos = {
    includes = [
      den.aspects.boot
    ];
    # host NixOS configuration
    nixos =
      { pkgs, ... }:
      {
        imports = [ ../_legacy/hosts/pc/hardware-configuration.nix ];
        environment.systemPackages = [ pkgs.hello ];
      };

    # host provides default home environment for its users
    provides.to-users.homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.vim ];
      };
  };
}
