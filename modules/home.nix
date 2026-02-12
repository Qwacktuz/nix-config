{ inputs, ... }:
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.modules.generic.hm-integration =
    {
      config,
      self,
      ...
    }:
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "bak"; # "backup"
        sharedModules = [
          { stylix.targets.spicetify.enable = false; }
        ];

        users.${config.userName} = {
          imports = with self.modules.homeManger; [
            hm # hm config
            packages
            zsh
            zsh_alias
            git
            nh
            direnv
            fastfetch
            starship
            micro
            bat
            fzf
            btop
            syncthing
            prismlauncher
            vscodium
            spicetify
            zed
            llm

            # vesktop
            # brave
            # music
          ];
        };

      };
    };

  flake.modules.homeManager.hm =
    {
      config,
      self,
      pkgs,
      ...
    }:
    let
      dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles";
      create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    in
    {
      # pass home-manager specific modules
      # HM is crosscompatible across different systems
      imports = [ self.modules.homeManager.kaktus ];

      # TODO: modularize all of this
      programs.home-manager.enable = true;
      programs.git.enable = true;

      # this doesn't work when configuring neovim non-nixified
      # home-manager will try to create init.lua and other neovim config files
      # which will cause conflict with symlinked neovim config files
      # it's most likely the same for other symlinked dotfiles
      # programs.neovim = {
      #   enable = true;
      #   vimAlias = true;
      # };
      home.packages = with pkgs; [
        aerospace
        # sketchybar
      ];

      # non-nixified dotfiles
      #home.file.".config/nvim".source = ./dotfiles/nvim; # This will make a nix store entry for our dotfiles (non-dynamic)
      # Symlinked/dynamic config file outside the nix store (dotfiles repo)
      xdg.configFile."nvim" = {
        source = create_symlink "${dotfiles}/nvim";
        #source = "./dotfiles/nvim";
        recursive = true;
      };

      xdg.configFile."karabiner" = {
        source = create_symlink "${dotfiles}/karabiner";
        recursive = true;
      };

      # xdg.configFile."sketchybar" = {
      #   source = create_symlink "${dotfiles}/sketchybar";
      #   recursive = true;
      # };

      # config for homebrew installed files
      home.file."Library/Application Support/com.mitchellh.ghostty" = {
        source = create_symlink "${dotfiles}/com.mitchellh.ghostty";
        recursive = true;
      };

      # Temporary SSH config
      home.file.".ssh/config".source = create_symlink "${dotfiles}/ssh/config";
    };

}
