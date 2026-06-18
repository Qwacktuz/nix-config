{ ... }:
{
  flake.modules.homeManager.btop =
    { pkgs, ... }:
    {
      programs.btop = {
        enable = true;

        settings = {
          update_ms = 500;
          rounded_corners = true;
        };
      };

      home.packages = pkgs.lib.optionals pkgs.stdenvNoCC.isDarwin (
        with pkgs.nvtopPackages;
        [
          # TODO: generalize for linux & darwin
          apple
          #full; ;
        ]
      );
    };
}
