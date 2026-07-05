{ config, ... }:

{
  flake.modules.darwin.profile-desktop = {
    imports = with config.flake.modules.darwin; [
      core
      profile-base
      aerospace
      homebrew
      stylix
      tailscale
    ];
  };
}
