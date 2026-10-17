{ config, ... }:

{
  flake.modules.homeManager.profile-darwin = {
    imports = with config.flake.modules.homeManager; [
      darwin-packages
      brave
      spicetify
      prismlauncher
      virtualization
    ];
  };
}
