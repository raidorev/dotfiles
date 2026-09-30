{ inputs, ... }:
{
  flake-file.inputs.llm-agents.url = "github:numtide/llm-agents.nix";

  den.aspects.llms = {
    nixos.nix.settings = {
      extra-substituters = [ "https://cache.numtide.com" ];
      extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
    };

    homeManager = { pkgs, ... }: {
      nixpkgs.overlays = [ inputs.llm-agents.overlays.shared-nixpkgs ];

      home.packages = with pkgs.llm-agents; [
        claude-code
        claude-desktop
        codex
        chatgpt
      ];
    };
  };
}
