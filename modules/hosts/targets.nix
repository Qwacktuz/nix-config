{
  inputs,
  config,
  lib,
  ...
}:
let
  mkDarwin =
    name: platform:
    inputs.nix-darwin.lib.darwinSystem {
      modules = [
        config.flake.modules.darwin.${name}
        { nixpkgs.hostPlatform = lib.mkDefault platform; }
      ];
    };
  mkNixos =
    name:
    {
      platform,
      extraModules ? [ ],
    }:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [
        config.flake.modules.nixos.${name}
        { nixpkgs.hostPlatform = lib.mkDefault platform; }
      ]
      ++ extraModules;
    };
in
{
  flake-file.inputs.apple-silicon.url = "github:nix-community/nixos-apple-silicon";

  flake.darwinConfigurations = lib.mapAttrs mkDarwin {
    saguaro = "aarch64-darwin";
    luna = "aarch64-darwin";
    sol = "aarch64-darwin";
  };

  flake.nixosConfigurations = lib.mapAttrs mkNixos {
    # Tailscale jump host homelab
    fishhook.platform = "x86_64-linux";

    # Asahi Linux host
    cholla = {
      platform = "aarch64-linux";
      extraModules = [ inputs.apple-silicon.nixosModules.apple-silicon-support ];
    };
  };
}
