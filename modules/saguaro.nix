{
  inputs,
  self,
  lib,
  config,
  ...
}:
let
  system = "aarch64-darwin";
in
{
  flake.darwinConfigurations.saguaro = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      self.modules.darwin.saguaro
      { nixpkgs.hostPlatform = lib.mkDefault system; }
    ];
  };

  flake.modules.darwin.saguaro = {
    imports = with self.modules; [
      darwin.kaktus
      generic.core
      darwin.mac-settings
      darwin.aerospace
      darwin.homebrew
      darwin.stylix

      # darwin.karabiner
      # darwin.sketchybar
      # darwin.sops
    ];
  };

  flake.modules.darwin.kaktus = {
    imports = [ inputs.home-manager.darwinModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "bak";

      # TODO: Move this to spicetify flake
      sharedModules = [
        { stylix.targets.spicetify.enable = false; }
      ];

      users.${config.userName} = {
        imports = with self.modules.homeManager; [
          kaktus
          hm-config # hm config

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

}
