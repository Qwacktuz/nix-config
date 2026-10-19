{ config, ... }:
{
  flake.modules.darwin.profile-full = {
    imports = with config.flake.modules.darwin; [
      profile-core
      profile-dev
      profile-gaming
      profile-creative
      profile-security
    ];
  };

  flake.modules.homeManager.profile-full = {
    imports = with config.flake.modules.homeManager; [
      profile-core
      profile-dev
      profile-gaming
      profile-creative
      profile-security
    ];
  };
}
