{
  den.aspects.media = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        vlc
        qimgv
        kooha
        parabolic
      ];
    };
  };
}
