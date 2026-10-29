{ self, config, ... }:
{
  flake.modules.darwin.sol =
    { ... }:
    {
      imports = with config.flake.modules.darwin; [
        profile-core
        profile-dev
        profile-creative
        config.flake.modules.darwin.${config.userName}
      ];

      networking.hostName = "sol";
      system.defaults.loginwindow.LoginwindowText = "Sol M2";

      nixpkgs.overlays = [
        self.overlays.default
      ];

      # Disable when using determinate nix
      nix.enable = false;
    };
}
