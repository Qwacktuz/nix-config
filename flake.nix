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
    tw93-mole = {
      url = "github:tw93/homebrew-tap";
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
      spotifyOverlay = final: prev: {
        spotify = prev.spotify.overrideAttrs (old: {
          src = prev.fetchurl {
            url = "https://download.scdn.co/SpotifyARM64.dmg";
            sha256 = "sha256-jOn4hPbxIQncdjkuySTsBaFzM6VpojbMMgph/Vpah1k=";
          };
        });
      };

      # globally set pkgs
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ spotifyOverlay ];
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
          nixpkgs.overlays = [ spotifyOverlay ];

          nix.settings.experimental-features = "nix-command flakes";
          nix.linux-builder.enable = true;

          fonts.packages = [
            pkgs.nerd-fonts.jetbrains-mono
          ];

          # openssh.authorizedKeys.keys = [
          #   (builtins.readFile ./pubkeys/saguaro_id_ed25519.pub)
          # ];

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

      devShells.${system}.default = pkgs.mkShell {
        name = "saguaro-dev";

        packages = with pkgs; [
          nil # Nix Language Server (LSP)
          #nixd # nix lsp
          nixfmt
          #nixpkgs-fmt # Formatter
          # TODO: treefmt with nix
          #treefmt-nix
          #nixfmt-tree
          sops # For editing your secrets
          age # Encryption needed for sops
          ssh-to-age # Helper for sops keys
          statix # Linter for Nix
          nix-diff
          shfmt
        ];

        # Environment variables and Aliases
        shellHook = ''
          # alias nix-apply="darwin-rebuild switch --flake .#saguaro"
          alias nix-apply="nh darwin switch .#saguaro"

          alias clean="nh clean all"

          alias fmt="nixfmt ."

          echo "🌵 Saguaro System Shell active. Run 'apply' to rebuild, 'fmt' to format or 'clean' to remove old gens"
        '';
      };
    };
}
