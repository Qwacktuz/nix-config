{ self, config, ... }:
{
  flake.modules.darwin.luna =
    darwin@{ lib, ... }:
    {
      imports = with config.flake.modules.darwin; [
        profile-full
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

      nixpkgs.overlays = [
        self.overlays.default
      ];

      # Disable when using determinate nix
      nix.enable = false;

      # Determinate reads this file even with nix-darwin's Nix management disabled.
      # M5 Pro / 24 GiB: leave headroom for interactive work during source builds.
      environment.etc."nix/nix.custom.conf".text = ''
        max-jobs = 2
        cores = 6
      '';
    };
}
