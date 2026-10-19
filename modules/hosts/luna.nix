{ self, config, ... }:
{
  flake.modules.darwin.luna =
    darwin@{ lib, ... }:
    {
      imports = with config.flake.modules.darwin; [
        profile-laptop
        profile-extras
        config.flake.modules.darwin.${config.userName}
      ];

      networking.hostName = "luna";
      system.defaults.loginwindow.LoginwindowText = "Luna M5";

      # sops.secrets.lockscreen_phone = {
      #   sopsFile = ../../secrets/luna.yaml;
      #   mode = "0400";
      # };

      # Run after sops-nix's mkAfter secret installation.
      # system.activationScripts.postActivation.text = lib.mkOrder 1600 ''
      #   lockscreen_phone="$(cat ${darwin.config.sops.secrets.lockscreen_phone.path})"
      #   /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow \
      #     LoginwindowText -string "if found contact $lockscreen_phone"
      #   unset lockscreen_phone
      # '';

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
