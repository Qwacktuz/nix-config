{ config, ... }:

{
  flake.homeManagerModules = config.flake.modules.homeManager;
  flake.nixosModules = config.flake.modules.nixos;
  flake.darwinModules = config.flake.modules.darwin;
}
