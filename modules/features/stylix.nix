{ inputs, ... }:
{
  flake-file.inputs.stylix.url = "github:nix-community/stylix";

  flake.modules.darwin.stylix =
    { config, lib, ... }:
    let
      wallpaper = config.stylix.image;
    in
    {
      imports = lib.optionals (inputs ? stylix) [ inputs.stylix.darwinModules.stylix ];

      stylix.enable = true;
      stylix.enableReleaseChecks = false;
      stylix.base16Scheme = import ../../assets/themes/catppuccin-mocha.nix;
      # Replace this path to select a different wallpaper for all Darwin hosts.
      stylix.image = ../../assets/wallpapers/spacegirl.png;

      home-manager.sharedModules = [
        (
          { config, lib, ... }:
          {
            programs.desktoppr = {
              enable = true;
              settings = {
                picture = wallpaper;
                scale = "fill";
                setOnlyOnce = false;
              };
            };

            launchd.agents.wallpaper = {
              enable = true;
              config = {
                ProgramArguments = [
                  (lib.getExe config.programs.desktoppr.package)
                  "manage"
                ];
                RunAtLoad = true;
                LimitLoadToSessionType = "Aqua";
              };
            };
          }
        )
      ];

      stylix.opacity.terminal = 0.7; # same as ghostty.nix

    };
}
