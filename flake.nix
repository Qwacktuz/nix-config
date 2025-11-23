{
  description = "Kaktus nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    psharma04-dorion = {
      url = "github:psharma04/homebrew-dorion";
      flake = false;
    };
    hashicorp-tap = {
      url = "github:hashicorp/homebrew-tap";
      flake = false;
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      #url = "github:0xc000022070/zen-browser-flake/beta"
      url = "github:0xc000022070/zen-browser-flake/beta";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # inputs@ before or @inputs after doesn't matter
  outputs =
    inputs@{
      self,
      nix-darwin,
      nixpkgs,
      sops-nix,
      home-manager,
      nix-homebrew,
      zen-browser,
      stylix,
      ...
    }:
    let
      # global flake configuration - should be modularzied to core or smth
      system = "aarch64-darwin";

      # Overlay to fix Spotify hash mismatch
      # spotifyOverlay = final: prev: {
      #   spotify = prev.spotify.overrideAttrs (old: {
      #     src = prev.fetchurl {
      #       url = "https://download.scdn.co/SpotifyARM64.dmg";
      #       sha256 = "sha256-fTyACxbyIgg7EwIgnNvNerJGUwAVLP2bg0TMnOegWeQ=";
      #     };
      #   });
      # };

      # globally set pkgs
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        # overlays = [ spotifyOverlay ];
      };

      # essentially a global config variable if imoprted
      customConfig = {
        username = "kaktus";
      };

      configuration =
        { pkgs, ... }:
        {
          nixpkgs.hostPlatform = system;
          # nixpkgs.config.allowUnfree = true;
          # nixpkgs.overlays = [ spotifyOverlay ];

          nix.settings.experimental-features = "nix-command flakes";
          nix.linux-builder.enable = true;

          environment.systemPackages = [ pkgs.nixfmt-rfc-style ];

          fonts.packages = [
            pkgs.nerd-fonts.jetbrains-mono
          ];

          # darwin specific, DRY-able pls /User vs /home
          users.users.${customConfig.username} = {
            home = "/Users/${customConfig.username}";
            name = customConfig.username;
          };
        };
    in
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#saguaro
      darwinConfigurations."saguaro" = nix-darwin.lib.darwinSystem {
        # pass spwecial args :3
        inherit system pkgs;
        specialArgs = { inherit self inputs customConfig; };
        modules = [
          configuration
          ./hosts/saguaro
          ./modules/system
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "bak"; # "backup"
              sharedModules = [
                { stylix.targets.spicetify.enable = false; }
              ];
              extraSpecialArgs = { inherit inputs customConfig; }; # Passing attrSets to HM
              users.${customConfig.username} = import ./home.nix;
            };
          }
        ];
      };
    };
}
