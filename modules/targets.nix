{
  inputs,
  self,
  lib,
  ...
}:
let
  darwin = "aarch64-darwin";
  nixos = "x86_64-linux";
in
{
  # Consume saguaro module
  flake.darwinConfigurations.saguaro = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      self.modules.darwin.saguaro
      { nixpkgs.hostPlatform = lib.mkDefault darwin; }
    ];
  };

  # flake.nixosConfigurations.<machine-name> = inputs.nixpkgs.lib.nixosSystem {
  #   modules = [
  #     self.modules.nixos.<machine-name>
  #     { nixpkgs.hostPlatform = lib.mkDefault nixos; }
  #   ];
  # };
}
