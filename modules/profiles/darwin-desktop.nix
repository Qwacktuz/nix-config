{ config, ... }:

{
  flake.modules.darwin.profile-desktop = {
    imports = with config.flake.modules.darwin; [
      core
      darwin-profile-base
      aerospace
      homebrew
      desktop-apps
      ghostty
      brave
      zed
      vscodium
      jetbrains
      virtualization
      yubikey
      stylix
      tailscale
    ];
  };
}
