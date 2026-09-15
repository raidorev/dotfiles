{ inputs, ... }:
{
  flake-file.inputs.nixpkgs-linux-firmware-fix.url = "github:NixOS/nixpkgs/a831408e6378bc02ebf8cc09b52c96ca86f6bab4";

  # https://github.com/NixOS/nixpkgs/issues/562919
  den.aspects.amdgpu-firmware-fix.nixos.nixpkgs.overlays = [
    (final: prev: {
      linux-firmware =
        inputs.nixpkgs-linux-firmware-fix.legacyPackages.${prev.stdenv.hostPlatform.system}.linux-firmware;
    })
  ];
}
