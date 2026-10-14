{ __findFile, ... }:
{
  # OVH VPS (KVM, legacy BIOS, 4 GB RAM).
  den.aspects.icewind = {
    includes = [
      <hosts/server>
      <disko>
      <podman>
      <firefly-iii>
    ];

    nixos = {
      imports = [ ./_hardware-configuration.nix ];

      boot.loader.limine = {
        efiSupport = false;
        biosSupport = true;
        biosDevice = "/dev/sda";
        # Limine's BIOS stage 2 lives in the EF02 partition below.
        partitionIndex = 1;
      };

      disko.devices.disk.main = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            bios = {
              priority = 1;
              size = "1M";
              type = "EF02";
            };
            # Limine only reads FAT, so /boot is vfat even without EFI.
            boot = {
              priority = 2;
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              priority = 3;
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };

      # Otherwise NetworkManager brings up its own "Wired connection 1"
      # (no IPv6) before the declarative profile below exists.
      networking.networkmanager.settings.main.no-auto-default = "*";

      # IPv4 comes from DHCP; OVH's IPv6 is static and its gateway sits
      # outside the /128, hence the on-link /64 route.
      networking.networkmanager.ensureProfiles.profiles.wan = {
        connection = {
          id = "wan";
          type = "ethernet";
        };
        ethernet.mac-address = "fa:16:3e:bb:63:72";
        ipv4.method = "auto";
        ipv6 = {
          method = "manual";
          address1 = "2607:5300:205:200::da57/128";
          gateway = "2607:5300:205:200::1";
          route1 = "2607:5300:205:200::/64";
        };
      };
    };
  };
}
