{ pkgs, inputs, ... }:
{
  # install package
  environment.systemPackages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    # ... maybe other stuff
  ];

  home-manager.users.raidorev = {
    home.file.".face".source = ../punk-cat;
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
      # settings = ./noctalia.json;
      # settings = {
      #   bar = {
      #     density = "compact";
      #     position = "right";
      #     showCapsule = false;
      #     widgets = {
      #       left = [
      #         {
      #           id = "ControlCenter";
      #           useDistroLogo = true;
      #         }
      #         {
      #           id = "Network";
      #         }
      #         {
      #           id = "Bluetooth";
      #         }
      #       ];
      #       center = [
      #         {
      #           hideUnoccupied = false;
      #           id = "Workspace";
      #           labelMode = "none";
      #         }
      #       ];
      #       right = [
      #         {
      #           alwaysShowPercentage = false;
      #           id = "Battery";
      #           warningThreshold = 30;
      #         }
      #         {
      #           formatHorizontal = "HH:mm";
      #           formatVertical = "HH mm";
      #           id = "Clock";
      #           useMonospacedFont = true;
      #           usePrimaryColor = true;
      #         }
      #       ];
      #     };
      #   };
      #   colorSchemes.predefinedScheme = "Monochrome";
      #   general = {
      #     avatarImage = "/home/drfoobar/.face";
      #     radiusRatio = 0.2;
      #   };
      #   location = {
      #     monthBeforeDay = true;
      #     name = "Marseille, France";
      #   };
      # };
    };
  };
}
