{ inputs, ... }:
{
  flake-file.inputs.spicetify-nix.url = "github:Gerg-L/spicetify-nix";

  flake.overlays.spotify = final: prev: {
    spotify = prev.spotify.overrideAttrs (old: {
      src = prev.fetchurl {
        url = "https://download.scdn.co/SpotifyARM64.dmg";
        sha256 = "sha256-vtAD7Jz4AQqTbAd0YtsS9aeBr1ES0YegLwB7A8XFKJc=";
      };
    });
  };

  flake.modules.homeManager.spicetify =
    { pkgs, lib, ... }:
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
    in
    {
      # imports = lib.optionals (inputs ? spicetify-nix) [
      #   inputs.spicetify-nix.homeManagerModules.spicetify
      # ];
      imports = [
        inputs.spicetify-nix.homeManagerModules.spicetify
      ];

      programs.spicetify = {
        enable = true;
        spotifyPackage = pkgs.spotify;
        theme = lib.mkDefault spicePkgs.themes.catppuccin;
        colorScheme = "mocha";
        enabledExtensions = with spicePkgs.extensions; [
          adblockify
          shuffle
        ];
      };
    };
}
