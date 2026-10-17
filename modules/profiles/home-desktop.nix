{ config, ... }:

{
  flake.modules.homeManager.profile-desktop = {
    imports = with config.flake.modules.homeManager; [
      ghostty
      gpu-monitor
      desktop-apps
      syncthing
    ];
  };
}
