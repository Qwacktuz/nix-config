{
  self,
  config,
  lib,
  ...
}:
{
  flake.modules.nixos.nixos-config =
    { pkgs, ... }:
    {
      # Basic system settings for cholla
      boot.loader.limine.enable = lib.mkDefault true;
      boot.loader.efi.canTouchEfiVariables = lib.mkDefault false;
      boot.kernelParams = [ "appledrm.show_notch=1" ];

      hardware.bluetooth.enable = true;

      networking = {
        hostName = "cholla";
        #domain = "homelab.${config.networkDomain}";
        useDHCP = lib.mkDefault true;
      };

      time.timeZone = "Europe/Oslo";

      system.stateVersion = lib.mkDefault "26.05";
    };
}
