{ config, ... }:

{
  flake.modules.nixos.profile-desktop = {
    imports = with config.flake.modules.nixos; [
      system-base
      tailscale
      ssh-server
    ];
  };
}
