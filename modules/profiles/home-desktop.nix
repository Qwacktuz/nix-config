{ config, ... }:

{
  flake.modules.homeManager.profile-desktop = {
    imports = with config.flake.modules.homeManager; [
      ghostty
      desktop-apps
      desktop-extra-apps
      syncthing
      music
    ];
  };
}
