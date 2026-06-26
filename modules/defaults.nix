{ lib, den, ... }:
{
  den.default.nixos.system.stateVersion = "26.11";
  den.default.homeManager.home.stateVersion = "26.11";
  den.default.includes = [ den.batteries.hostname ];

  # enable hm by default
  den.schema.user.classes = lib.mkDefault [ "homeManager" ];
}
