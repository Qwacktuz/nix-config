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
        config.flake.modules.nixos.${config.userName}
      ];

      home-manager.users.${config.userName}.imports = [
        config.flake.modules.homeManager.profile-full
      ];

      nixpkgs.overlays = [
        self.overlays.default
      ];
    };
}
