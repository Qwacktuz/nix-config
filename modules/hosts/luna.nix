{ config, ... }:
{
  flake.modules.darwin.luna = {
    imports = with config.flake.modules.darwin; [
      profile-full
      config.flake.modules.darwin.${config.userName}
    ];

    networking.hostName = "luna";
    system.defaults.loginwindow.LoginwindowText = "Luna M5";

    # Determinate reads this file even with nix-darwin's Nix management disabled.
    # M5 Pro / 24 GiB: leave headroom for interactive work during source builds.
    environment.etc."nix/nix.custom.conf".text = ''
      max-jobs = 2
      cores = 6
    '';
  };
}
