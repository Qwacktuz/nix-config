# DO-NOT-EDIT. This file was auto-generated using github:vic/flake-file.
# Use `nix run .#write-flake` to regenerate it.
{
  description = "Kaktus nix flake";

  outputs = inputs: import ./outputs.nix inputs;

  inputs = {
    flake-file.url = "github:vic/flake-file";
    flake-parts = {
      inputs.nixpkgs-lib.follows = "nixpkgs";
      url = "github:hercules-ci/flake-parts";
    };
    hashicorp-tap = {
      flake = false;
      url = "github:hashicorp/homebrew-tap";
    };
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager";
    };
    homebrew-cask = {
      flake = false;
      url = "github:homebrew/homebrew-cask";
    };
    homebrew-core = {
      flake = false;
      url = "github:homebrew/homebrew-core";
    };
    import-tree.url = "github:vic/import-tree";
    nix-darwin = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-darwin/nix-darwin/master";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-lib.follows = "nixpkgs";
    nur = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/NUR";
    };
    psharma04-dorion = {
      flake = false;
      url = "github:psharma04/homebrew-dorion";
    };
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };
    spicetify-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:Gerg-L/spicetify-nix";
    };
    stylix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/stylix";
    };
    systems.url = "github:nix-systems/default";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    tw93-mole = {
      flake = false;
      url = "github:tw93/homebrew-tap";
    };
    zen-browser = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:0xc000022070/zen-browser-flake/beta";
    };
  };

}
