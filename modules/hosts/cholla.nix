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

      home-manager.users.${config.userName}.imports = [
        config.flake.modules.homeManager.profile-extras
      ];

      nixpkgs.overlays = [
        self.overlays.default
        self.overlays.spotify
      ];
    };
}
