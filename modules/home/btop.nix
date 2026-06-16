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

      home.packages = with pkgs.nvtopPackages; [
        # TODO: generalize for linux & darwin
        apple
        #full; ;
      ];
    };
}
