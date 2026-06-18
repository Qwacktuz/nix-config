{ config, ... }:

{
  flake.modules.nixos.profile-server = {
    imports = with config.flake.modules.nixos; [
      core
      tailscale
      ssh-server
    ];
  };
}
