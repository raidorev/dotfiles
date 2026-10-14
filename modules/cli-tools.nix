{
  den.aspects.cli-tools = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        eza
        ripgrep
        fd
        bat
        jq
        htop
        lazyjournal
      ];
    };
  };
}
