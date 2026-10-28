{
  flake.modules.homeManager.syncthing =
    { pkgs, ... }:
    {
      services.syncthing = {
        enable = true;
        package = pkgs.syncthing;
      };
    };
}
