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

  # Tailscale jump host homelab
  flake.nixosConfigurations.fishhook = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.modules.nixos.fishhook
      { nixpkgs.hostPlatform = lib.mkDefault nixos; }
    ];
  };
}
