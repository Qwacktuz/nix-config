{ inputs, lib, ... }:
{
  imports = [
    inputs.flake-file.flakeModules.dendritic
  ];

  systems = lib.mkDefault (import inputs.systems);

  flake-file = {
    description = "Kaktus nix flake";
    inputs = {
      # -- System & Configuration --
      flake-file.url = "github:vic/flake-file";

      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      nixpkgs-lib.follows = "nixpkgs";

      flake-parts.url = "github:hercules-ci/flake-parts";
      flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

      systems.url = "github:nix-systems/default";

      nix-darwin.url = "github:nix-darwin/nix-darwin/master";
      nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

      home-manager.url = "github:nix-community/home-manager";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";

      nix-homebrew.url = "github:zhaofengli/nix-homebrew";

      # -- Utilities & Overlays --
      devshell.url = "github:numtide/devshell";
      devshell.inputs.nixpkgs.follows = "nixpkgs";

      treefmt-nix.url = "github:numtide/treefmt-nix";

      sops-nix.url = "github:Mic92/sops-nix";
      sops-nix.inputs.nixpkgs.follows = "nixpkgs";

      nur.url = "github:nix-community/NUR";
      nur.inputs.nixpkgs.follows = "nixpkgs";

      stylix.url = "github:nix-community/stylix";
      stylix.inputs.nixpkgs.follows = "nixpkgs";

      import-tree.url = "github:vic/import-tree";

      # -- Applications --
      zen-browser.url = "github:0xc000022070/zen-browser-flake/beta";
      zen-browser.inputs.nixpkgs.follows = "nixpkgs";

      spicetify-nix.url = "github:Gerg-L/spicetify-nix";
      spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

      # -- Raw Sources (flake = false) --
      # You cannot use .follows on these
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

      # pubkeys = {
      #   url = "path:./pubkeys";
      #   flake = false;
      # };
    };

    # Generated automatically
    # outputs = lib.mkDefault ''
    #   inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules)
    # '';
  };
}
