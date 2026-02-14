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

  flake.overlays.spotify = final: prev: {
    spotify = prev.spotify.overrideAttrs (old: {
      src = prev.fetchurl {
        url = "https://download.scdn.co/SpotifyARM64.dmg";
        sha256 = "sha256-i/+w9s/3ZQtLAEMVTcLaV69fhpKq2rT5+WoBzer0ahY=";
      };
    });
  };

  flake.modules.generic.core =
    { pkgs, ... }:
    {
      nixpkgs.hostPlatform = lib.mkDefault system;
      nixpkgs.config.allowUnfree = lib.mkDefault true;
      nix.settings.experimental-features = lib.mkDefault "nix-command flakes";
      nixpkgs.overlays = [ self.overlays.spotify ];

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
