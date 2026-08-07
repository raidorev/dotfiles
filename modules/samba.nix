{
  den.aspects.samba = {
    user.extraGroups = [ "samba" ];

    nixos = {
      services.samba = {
        enable = true;
        openFirewall = false;
        usershares.enable = true;
        settings.global = {
          "workgroup" = "WORKGROUP";
          "server min protocol" = "SMB3";
          "usershare allow guests" = false;
          "usershare owner only" = true;
          "hosts allow" = "192.168.122.0/24 127.0.0.1"; # libvirt NAT + loopback
          "hosts deny" = "0.0.0.0/0";
        };
      };
    };
  };
}
