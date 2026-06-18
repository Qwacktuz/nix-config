{ config, ... }:

{
  flake.modules.darwin.profile-laptop = {
    imports = [
      config.flake.modules.darwin.profile-desktop
    ];
  };
}
