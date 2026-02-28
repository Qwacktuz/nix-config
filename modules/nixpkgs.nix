{
  inputs,
  ...
}:
{
  imports = [ inputs.flake-parts.flakeModules.easyOverlay ];

  # Flake level config
  perSystem =
    {
      system,
      pkgs,
      lib,
      ...
    }:
    {
      # Overrides the default 'pkgs' argument for all perSystem modules
      # for example devshells, formatter, checks
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = lib.mkDefault true;
      };

      # Using easyOverlay, you use pkgs directly instead of referencing prev
      overlayAttrs = {
        xrdb = pkgs.xorg.xrdb;
        yt-dlp = pkgs.yt-dlp.overridePythonAttrs (oldAttrs: {
          dependencies = lib.filter (
            dep:
            !(lib.elem dep.pname [
              "cffi"
              "secretstorage"
            ])
          ) oldAttrs.dependencies;
        });
      };
    };

  # flake.overlays.xrdb = final: prev: {
  #   # change name from xrdb to xorg.xrdb
  #   xrdb = prev.xorg.xrdb;
  # };
}
