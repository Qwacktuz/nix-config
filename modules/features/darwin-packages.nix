{ ... }:
{
  flake.modules.homeManager.darwin-packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        aerospace
        # sketchybar
        stats
        iina
      ];
    };
}
