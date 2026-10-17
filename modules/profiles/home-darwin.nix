{ config, ... }:

{
  flake.modules.homeManager.profile-darwin = {
    imports = with config.flake.modules.homeManager; [
      darwin-tools
      brave
    ];
  };
}
