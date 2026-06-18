{ config, ... }:

{
  flake.modules.homeManager.profile-desktop = {
    imports = with config.flake.modules.homeManager; [
      syncthing
      music
    ];
  };
}
