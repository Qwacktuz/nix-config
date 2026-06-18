{
  self,
  config,
  ...
}:
{
  flake.modules.nixos.cholla =
    { ... }:
    {
      imports = with config.flake.modules.nixos; [
        profile-desktop
        hardware-cholla
        user-kaktus-desktop
      ];

      nixpkgs.overlays = [
        self.overlays.default
        self.overlays.spotify
      ];
    };
}
