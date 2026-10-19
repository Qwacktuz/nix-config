{ config, ... }:
{
  flake.modules.darwin.profile-creative = {
    home-manager.users.${config.userName}.imports = [
      config.flake.modules.homeManager.profile-creative
    ];
    homebrew.casks = [
      "obs"
      "focusrite-control-2"
      "wacom-tablet"
    ];
  };

  flake.modules.homeManager.profile-creative = { pkgs, lib, ... }: {
    imports = with config.flake.modules.homeManager; [
      music
    ];
    home.packages =
      (with pkgs; [
        tenacity
        mpv
        (ani-cli.override { withMpv = !pkgs.stdenv.hostPlatform.isDarwin; })
        ffmpeg
        gifsicle
        imagemagick
        mermaid-cli
        viu
        typst
        typship
        typstPackages.fontawesome
        glow
        ghostscript
        tectonic
        texliveSmall
        ltex-ls-plus
      ])
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (
        builtins.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) (
          with pkgs;
          [
            xournalpp
            obs-studio
            libreoffice
            hieroglyphic
          ]
        )
      )
      ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin (
        with pkgs;
        [
          xournalpp
        ]
      );
  };
}
