{ inputs, ... }:
{
  flake.modules.homeManager.spicetify =
    { pkgs, ... }:
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
    in
    {
      imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

      programs.spicetify = {
        enable = true;
        spotifyPackage = pkgs.spotify;
        theme = spicePkgs.themes.catppuccin; # stylix autothemes for us
        colorScheme = "mocha";
        enabledExtensions = with spicePkgs.extensions; [
          adblockify
          shuffle
        ];
      };
    };
}
