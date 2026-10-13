{ self, config, ... }:
{
  flake.modules.darwin.luna = {
    imports = with config.flake.modules.darwin; [
      profile-desktop
      config.flake.modules.darwin.${config.userName}
    ];

    networking.hostName = "luna";

    nixpkgs.overlays = [
      self.overlays.default
      self.overlays.spotify
    ];

    # Disable when using determinate nix
    nix.enable = false;
  };
}
