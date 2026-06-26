{ __findFile, ... }:
{
  den.aspects.laptop = { host, ... }: {
    includes = [
      <boot>
      <locale>
      <nix-settings>
      <audio>
      <nvidia>
    ];

    nixos = { pkgs, ... }: {
      imports = [ ../hosts/laptop/hardware-configuration.nix ];

      networking.networkmanager.enable = true;

      environment.systemPackages = with pkgs; [
        vim
        wget
      ];
    };
  };
}
