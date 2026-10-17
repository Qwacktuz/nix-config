{
  flake.modules.homeManager.darwin-packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        # aerospace # see aerospace.nix
        # sketchybar
        stats
        iina
        macpm # Activity Monitor replacement for Mac
        #notion-app # Note taking app
        xcodes
      ];
    };
}
