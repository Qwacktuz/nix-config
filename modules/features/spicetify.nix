{ inputs, ... }:
{
  flake-file.inputs.spicetify-nix.url = "github:Gerg-L/spicetify-nix";

  flake.modules.darwin.spicetify.homebrew.casks = [ "spotify" ];

  flake.modules.homeManager.spicetify =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
      cfg = config.programs.spicetify;
      extensions = cfg.enabledExtensions ++ cfg.theme.requiredExtensions;
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.system};
    in
    {
      stylix.targets.spicetify.enable = lib.mkDefault false;

      imports = [
        inputs.spicetify-nix.homeManagerModules.spicetify
      ];

      programs.spicetify = {
        enable = !isDarwin;
        spotifyPackage = pkgs.spotify;
        theme = lib.mkDefault spicePkgs.themes.catppuccin;
        colorScheme = "mocha";
        enabledExtensions = with spicePkgs.extensions; [
          adblockify
          shuffle
        ];
      };

      xdg.configFile = lib.mkIf isDarwin (
        {
          "spicetify/Themes/${cfg.theme.name}".source = cfg.theme.src;
        }
        // builtins.listToAttrs (
          map (extension: {
            name = "spicetify/Extensions/${extension.name}";
            value.source = "${extension.src}/${extension.name}";
          }) extensions
        )
      );

      # Spotify stays owned by its cask. Apply customization explicitly after
      # opening Spotify once, and reapply after Spotify upgrades.
      home.packages = lib.optionals isDarwin [
        cfg.spicetifyPackage
        (pkgs.writeShellScriptBin "spicetify-apply" ''
          set -eu
          export SPICETIFY_CONFIG=${lib.escapeShellArg "${config.xdg.configHome}/spicetify"}
          spicetify=${lib.escapeShellArg (lib.getExe cfg.spicetifyPackage)}
          "$spicetify" config \
            spotify_path /Applications/Spotify.app/Contents/Resources \
            prefs_path "$HOME/Library/Application Support/Spotify/prefs" \
            current_theme ${lib.escapeShellArg cfg.theme.name} \
            color_scheme ${lib.escapeShellArg cfg.colorScheme} \
            inject_css ${if cfg.theme.injectCss then "1" else "0"} \
            inject_theme_js ${if cfg.theme.injectThemeJs then "1" else "0"} \
            replace_colors ${if cfg.theme.replaceColors then "1" else "0"} \
            overwrite_assets ${if cfg.theme.overwriteAssets then "1" else "0"} \
            check_spicetify_update 0
          "$spicetify" config extensions ${
            lib.escapeShellArg (lib.concatMapStringsSep "|" (extension: extension.name) extensions)
          }
          exec "$spicetify" --no-restart backup apply
        '')
      ];
    };
}
