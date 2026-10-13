{ config, ... }:

{
  flake.modules.homeManager.profile-darwin = {
    imports = with config.flake.modules.homeManager; [
      darwin-packages
      home-packages
      brave
      spicetify
      prismlauncher
      virtualization
    ];
  };
}
