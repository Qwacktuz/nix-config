{ ... }:
{
  flake.modules.homeManager.syncthing =
    {
      pkgs,
      ...
    }:
    {
      # home.packages = with pkgs; [
      #   syncthing-macos
      # ];
      services.syncthing = {
        enable = true;
        package = pkgs.syncthing;
        # Not supported on darwin
        # tray.enable = true;

        # settings = {
        #
        # };
      };
    };
}
