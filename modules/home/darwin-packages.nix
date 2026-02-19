{ ... }:
{
  flake.modules.homeManager.darwin-packages =
    { pkgs, ... }:
    {

      # home.packages for darwin only
      home.packages =
        if pkgs.stdenvNoCC.isDarwin then
          with pkgs;
          [
            stats
            iina
          ]
        else
          [
            # No packages if not on darwin
          ];
    };
}
