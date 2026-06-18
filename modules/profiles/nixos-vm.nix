{ config, ... }:

{
  flake.modules.nixos.profile-vm = {
    imports = [
      config.flake.modules.nixos.profile-server
    ];
  };
}
