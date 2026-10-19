{
  inputs,
  config,
  lib,
  ...
}:
let
  darwin = "aarch64-darwin";
  nixos = "x86_64-linux";
  asahi = "aarch64-linux";
in
{
  # Consume saguaro module
  flake.darwinConfigurations.saguaro = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      config.flake.modules.darwin.saguaro
      { nixpkgs.hostPlatform = lib.mkDefault darwin; }
    ];
  };

  flake.darwinConfigurations.luna = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      config.flake.modules.darwin.luna
      { nixpkgs.hostPlatform = lib.mkDefault darwin; }
    ];
  };

  flake.darwinConfigurations.sol = inputs.nix-darwin.lib.darwinSystem {
    modules = [
      config.flake.modules.darwin.luna
      { nixpkgs.hostPlatform = lib.mkDefault darwin; }
    ];
  };

  # Tailscale jump host homelab
  flake.nixosConfigurations.fishhook = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      config.flake.modules.nixos.fishhook
      { nixpkgs.hostPlatform = lib.mkDefault nixos; }
    ];
  };

  # aarch64-linux target host cholla
  flake-file.inputs.apple-silicon.url = "github:nix-community/nixos-apple-silicon";
  flake.nixosConfigurations.cholla = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      config.flake.modules.nixos.cholla
      { nixpkgs.hostPlatform = lib.mkDefault asahi; }
    ]
    ++ lib.optionals (inputs ? apple-silicon) [
      inputs.apple-silicon.nixosModules.apple-silicon-support
    ];
  };
}
