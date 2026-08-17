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
