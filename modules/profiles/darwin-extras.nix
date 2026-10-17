{ config, ... }:
{
  flake.modules.darwin.profile-extras = {
    imports = with config.flake.modules.darwin; [
      apps-communication
      apps-games
      apps-peripherals
      apps-creative
      apps-browsers
      apps-security
      apps-dev-extras
      apps-backup
      apps-study
      apps-extra-tools
      virtualization-vms
    ];
  };
}
