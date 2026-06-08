{ inputs, lib, ... }:
{
  imports = [
    inputs.flake-file.flakeModules.dendritic
    inputs.flake-file.flakeModules.nix-auto-follow
  ];

  /*
    flakeModules.dendritic
    - Includes flakeModules.default.
    - Includes flakeModules.import-tree.
    - Enables flake-parts.
    - Sets outputs to inputs: inputs.flake-parts.lib.mkFlake { inherit inputs; } (inputs.import-tree ./modules).
  */

  systems = lib.mkDefault (import inputs.systems);

  flake-file = {
    prune-lock.enable = true;
    description = "Kaktus nix flake";
    inputs = {
      flake-file.url = "github:vic/flake-file";

      # -- System & Configuration --
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
      nixpkgs-lib.follows = "nixpkgs";
      systems.url = "github:nix-systems/default";
      nix-darwin.url = "github:nix-darwin/nix-darwin/master";
      home-manager.url = "github:nix-community/home-manager/master";

      # -- Utilities & Overlays --
      # nur.url = "github:nix-community/NUR";

      # -- Raw Sources (flake = false) --
      homebrew-core = {
        url = "github:homebrew/homebrew-core";
        flake = false;
      };
      homebrew-cask = {
        url = "github:homebrew/homebrew-cask";
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
      #   url = "path:../pubkeys";
      #   flake = false;
      # };
    };
  };
}
