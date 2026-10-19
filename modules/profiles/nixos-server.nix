{ config, ... }:

{
  flake.modules.nixos.profile-server = {
    imports = with config.flake.modules.nixos; [
      system-base
      tailscale
      ssh-server
    ];
  };
}
