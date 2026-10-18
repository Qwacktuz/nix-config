{ self, config, ... }:
{
  flake.modules.darwin.luna = {
    imports = with config.flake.modules.darwin; [
      profile-laptop
      profile-extras
      config.flake.modules.darwin.${config.userName}
    ];

    networking.hostName = "luna";

    home-manager.users.${config.userName}.imports = with config.flake.modules.homeManager; [
      profile-extras
      profile-darwin-extras
    ];

    nixpkgs.overlays = [
      self.overlays.default
    ];

    # Disable when using determinate nix
    nix.enable = false;
  };
}
