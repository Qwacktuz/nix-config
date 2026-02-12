{ config, lib, ... }:
{

  flake.modules.generic =
    { pkgs, system, ... }:
    let
      # FIXME: This is not ideal to stay in generic becuase it is darwin only
      spotifyOverlay = final: prev: {
        spotify = prev.spotify.overrideAttrs (old: {
          src = prev.fetchurl {
            url = "https://download.scdn.co/SpotifyARM64.dmg";
            sha256 = "sha256-i/+w9s/3ZQtLAEMVTcLaV69fhpKq2rT5+WoBzer0ahY=";
          };
        });
      };
    in
    {
      options = {
        userName = lib.mkOption {
          type = lib.types.str;
          default = "default";
          description = "User name for the configuration";
        };
      };

      config = {
        userName = "kaktus"; # Reference the option or set flake outputs
      };

      nix.settings.experimental-features = "nix-command flakes";
      nixpkgs.hostPlatform = system;
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [ spotifyOverlay ];

      # Not quite sure if this should be here too
      nix.linux-builder.enable = true;

      # Not quite sure if this should be here too
      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
      ];

      # openssh.authorizedKeys.keys = [
      #   (builtins.readFile ./pubkeys/saguaro_id_ed25519.pub)
      # ];
    };
}
