{
  self,
  config,
  lib,
  ...
}:
{
  flake.modules.nixos.hardware-cholla =
    { pkgs, ... }:
    {
      # Basic system settings for cholla
      boot.loader.limine.enable = lib.mkDefault true;
      boot.loader.efi.canTouchEfiVariables = lib.mkDefault false;
      boot.kernelParams = [ "appledrm.show_notch=1" ];

      services.desktopManager.plasma6.enable = true;
      services.displayManager.plasma-login-manager.enable = true;

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
