{
  den.aspects.zed = { user, ... }: {
    homeManager = { pkgs, ... }: {
      home.packages = [ pkgs.zed-editor ];
      programs.zed-editor = {
        enable = true;
        extensions = [
          "nix"
          "catppuccin"
          "catppuccin-icons"
          "qml"
        ];
        userSettings = {
          vim_mode = true;
          load_direnv = "shell_hook";
          icon_theme = {
            mode = "system";
            light = "Catppuccin Latte";
            dark = "Catppuccin Mocha";
          };
          lsp.nix.binary.path_lookup = true;
        };
      };
    };
  };
}
