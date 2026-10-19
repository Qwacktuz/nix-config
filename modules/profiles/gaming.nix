{ config, ... }:
{
  flake.modules.darwin.profile-gaming = {
    home-manager.users.${config.userName}.imports = [
      config.flake.modules.homeManager.profile-gaming
    ];
    homebrew.casks = [
      "parsec"
      "steam"
      "nvidia-geforce-now"
      "prismlauncher"
    ];
  };

  flake.modules.homeManager.profile-gaming = { pkgs, lib, ... }: {
    home.packages =
      (with pkgs; [
        toipe
        ttyper
        cbonsai
        cmatrix
        kittysay
        neo-cowsay
      ])
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (
        builtins.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) (
          with pkgs;
          [
            parsec-bin
          ]
        )
      );
  };
}
