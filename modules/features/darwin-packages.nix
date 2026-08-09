{
  flake.modules.homeManager.darwin-packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        aerospace
        # sketchybar
        stats
        iina
        nvtopPackages.apple # GPU monitor
        macpm # Activity Monitor replacement for Mac
        notion-app # Note taking app
        xcodes
      ];
    };
}
