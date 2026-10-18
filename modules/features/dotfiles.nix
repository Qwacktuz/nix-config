{ ... }:
{
  flake.modules.homeManager.dotfiles =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles";
      create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    in
    {
      home.enableNixpkgsReleaseCheck = false;
      programs.home-manager.enable = true;

      home.packages = with pkgs; [
        neovim
      ];

      xdg.dataFile."nvim/site/spell/nb.utf-8.spl".source = pkgs.fetchurl {
        url = "https://ftp.nluug.nl/pub/vim/runtime/spell/nb.utf-8.spl";
        hash = "sha256-PImo8hi6Wk9Lt+OO6O+yFezcE2/R4lFTIihEZ7JD/88=";
      };
      xdg.dataFile."nvim/site/spell/nb.utf-8.sug".source = pkgs.fetchurl {
        url = "https://ftp.nluug.nl/pub/vim/runtime/spell/nb.utf-8.sug";
        hash = "sha256-BlcGNG9uB7mL6+mFwoeR8zcY5GUg+V75kcey79bhHig=";
      };

      xdg.configFile."nvim" = {
        source = create_symlink "${dotfiles}/nvim";
        recursive = true;
      };

      xdg.configFile."karabiner" = lib.mkIf pkgs.stdenvNoCC.hostPlatform.isDarwin {
        source = create_symlink "${dotfiles}/karabiner";
        recursive = true;
      };
    };
}
