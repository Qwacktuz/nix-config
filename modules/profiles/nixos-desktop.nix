{ config, ... }:

{
  flake.modules.nixos.profile-desktop = {
    imports = with config.flake.modules.nixos; [
      core
      tailscale
      ssh-server
    ];
  };
}
