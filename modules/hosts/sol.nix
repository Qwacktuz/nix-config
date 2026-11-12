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

      # Determinate reads this file even with nix-darwin's Nix management disabled.
      # M2 / 16 GiB: limit concurrent compilers to reduce memory pressure.
      environment.etc."nix/nix.custom.conf".text = ''
        max-jobs = 2
        cores = 4
      '';
    };
}
