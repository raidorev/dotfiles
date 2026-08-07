{
  den.aspects.libvirt = {
    user.extraGroups = [
      "libvirtd"
      "kvm"
    ];

    nixos = { pkgs, ... }: {
      virtualisation.libvirtd = {
        enable = true;

        # Don't resume guests on host boot; VMs marked autostart still start.
        onBoot = "ignore";
        onShutdown = "shutdown";

        qemu.swtpm.enable = true;
      };

      programs.virt-manager.enable = true;

      networking.firewall.trustedInterfaces = [ "virbr0" ];

      environment.systemPackages = with pkgs; [
        qemu
        quickemu

        remmina
        freerdp
        virt-viewer
      ];
    };
  };
}
