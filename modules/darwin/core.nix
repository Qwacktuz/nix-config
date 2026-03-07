{
  self,
  config,
  lib,
  ...
}:
{
  flake.modules.darwin.core = {
    imports = with self.modules; [
      generic.core
      darwin.mac-settings
      darwin.${config.userName}
    ];

    nixpkgs.overlays = [
      self.overlays.default
      self.overlays.spotify
    ];

    # Small VM that builds x86_64-linux systems anywhere!
    # Might move to darwin module
    nix.linux-builder = {
      enable = lib.mkDefault true;
      config.boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
    };
  };
}
