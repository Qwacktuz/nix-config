{ self, config, ... }:
{
  flake.modules.darwin.sol =
    darwin@{ lib, ... }:
    {
      imports = with config.flake.modules.darwin; [
        profile-laptop
        profile-extras
        config.flake.modules.darwin.${config.userName}
      ];

      networking.hostName = "luna";
      system.defaults.loginwindow.LoginwindowText = "Sol M2";

      # home-manager.users.${config.userName}.imports = with config.flake.modules.homeManager; [
      # profile-extras
      # profile-darwin-extras
      # ];

      nixpkgs.overlays = [
        self.overlays.default
      ];

      # Disable when using determinate nix
      nix.enable = false;
    };
}
