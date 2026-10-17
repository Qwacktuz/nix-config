{ config, ... }:
{
  flake.modules.homeManager.profile-extras = {
    imports = with config.flake.modules.homeManager; [
      personal-tools
      security-tools
      desktop-extra-apps
      creative-apps
      music
    ];
  };
  flake.modules.homeManager.profile-darwin-extras = {
    imports = with config.flake.modules.homeManager; [
      spicetify
      virtualization-vms
    ];
  };
}
