{
  self,
  config,
  lib,
  ...
}:
{
  flake.modules.nixos.cholla =
    { modulesPath, ... }:
    {
      imports = with self.modules; [
        generic.core
        nixos.nixos-config
        nixos.${config.userName}
        nixos.tailscale
        nixos.ssh-server
      ];

      nixpkgs.overlays = [
        self.overlays.default
        self.overlays.spotify
      ];
    };
}
