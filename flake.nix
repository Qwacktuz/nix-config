# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "Kaktus nix flake";

  outputs = inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules);

  inputs = {
    devenv.url = "github:cachix/devenv";
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs-lib";
    };
    hashicorp-tap = {
      url = "github:hashicorp/homebrew-tap";
      flake = false;
    };
    home-manager.url = "github:nix-community/home-manager";
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    import-tree.url = "github:vic/import-tree";
    nix-auto-follow = {
      url = "github:fzakaria/nix-auto-follow";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nix-jetbrains-plugins.url = "github:nix-community/nix-jetbrains-plugins";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-lib.follows = "nixpkgs";
    psharma04-dorion = {
      url = "github:psharma04/homebrew-dorion";
      flake = false;
    };
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    stylix.url = "github:nix-community/stylix";
    systems.url = "github:nix-systems/default";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    tw93-mole = {
      url = "github:tw93/homebrew-tap";
      flake = false;
    };
  };
}
