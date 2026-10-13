{ config, ... }:

{
  flake.modules.darwin.profile-desktop = {
    imports = with config.flake.modules.darwin; [
      core
      darwin-profile-base
      aerospace
      homebrew
      stylix
      tailscale
    ];
  };
}
