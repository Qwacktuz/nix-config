{ self, config, ... }:
{
  flake.modules.darwin.saguaro = {
    imports = with config.flake.modules.darwin; [
      profile-full
      config.flake.modules.darwin.${config.userName}
    ];

    networking.hostName = "saguaro";
    system.defaults.loginwindow.LoginwindowText = "Saguaro M4";

    nixpkgs.overlays = [
      self.overlays.default
    ];

    # Disable when using determinate nix
    nix.enable = false;

  };
}
