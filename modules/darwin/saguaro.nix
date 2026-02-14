{
  inputs,
  self,
  system,
  lib,
  config,
  ...
}:
{
  # flake.modules.darwin.saguaro = {
  # inherit system;
  # specialArgs = { inherit inputs self; };
  # modules = [
  #   config.flake.modules.darwin.saguaro
  # ];
  # };

  # flake.darwinModules.darwin.saguaro = inputs.nix-darwin.lib.darwinSystem {
  flake.darwinConfigurations.saguaro = inputs.nix-darwin.lib.darwinSystem {
    inherit system;
    specialArgs = { inherit inputs self; };

    modules = [
      inputs.home-manager.darwinModules.home-manager
      {
        nixpkgs.hostPlatform = lib.mkDefault "aarch64-darwin";
        nixpkgs.config.allowUnfree = lib.mkDefault true;
        nix.settings.experimental-features = lib.mkDefault "nix-command flakes";
        nixpkgs.overlays = [ self.overlays.spotify ];

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "bak";
          sharedModules = [
            { stylix.targets.spicetify.enable = false; }
          ];
          extraSpecialArgs = { inherit inputs self; };
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

        imports = [
          # self.modules.generic.core
          self.modules.darwin.kaktus
          self.modules.darwin.mac-settings
          self.modules.darwin.aerospace
          self.modules.darwin.homebrew
          self.modules.darwin.stylix
          # darwin.karabiner
          # darwin.sketchybar
          # darwin.sops
        ];
      }
    ];

  };

  flake.overlays.spotify = final: prev: {
    spotify = prev.spotify.overrideAttrs (old: {
      src = prev.fetchurl {
        url = "https://download.scdn.co/SpotifyARM64.dmg";
        sha256 = "sha256-i/+w9s/3ZQtLAEMVTcLaV69fhpKq2rT5+WoBzer0ahY=";
      };
    });
  };

  flake.modules.generic.core =
    { pkgs, self, ... }:
    {
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
