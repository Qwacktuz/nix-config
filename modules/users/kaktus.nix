{
  inputs,
  self,
  config,
  ...
}:
let
  inherit (config) userName;
in
{
  flake.modules.darwin.${userName} = {
    imports = [ inputs.home-manager.darwinModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";

      # TODO: Move this to spicetify flake
      sharedModules = [
        { stylix.targets.spicetify.enable = false; }
      ];

      users.${userName} = {
        imports =
          with self.modules.homeManager;
          [
            darwin-packages

            virtualization
            ssh-client
            languagetool
            fonts
            jetbrains
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
            music
          ]
          ++ [ self.modules.homeManager.${userName} ];
      };
    };
  };
}
