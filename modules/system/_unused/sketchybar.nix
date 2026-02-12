{ ... }:
{
  flake.modules.darwin.sketchybar =
    { pkgs, ... }:
    {
      # home-manager module
      # programs.sketchybar = {
      #   enable = true;
      #   # this conflicts with the xdg way of doing it
      #   config = builtins.readFile ./sketchybarrc;
      #   configtype = "bash"; # lua
      #   extraPackages = with pkgs; [
      #     jq
      #     sketchybar-app-font
      #   ];
      # };

      # nix-darwin module
      services.sketchybar = {
        enable = true;
        extraPackages = with pkgs; [
          sketchybar-app-font
          jq
        ];
      };
    };
}
