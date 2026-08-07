{
  den.aspects.qbittorrent = {
    nixos.services.qbittorrent = {
      enable = true;
      webuiPort = 4567;
    };
  };
}
