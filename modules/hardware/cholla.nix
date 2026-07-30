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
      # imports = [ ./cholla-hwconfig.nix ];
      imports = with config.flake.modules.nixos; [
        cholla-hwconfig
      ];

      # Basic system settings for cholla
      boot.loader.limine.enable = lib.mkDefault true;
      boot.loader.efi.canTouchEfiVariables = lib.mkDefault false;
      boot.kernelParams = [ "appledrm.show_notch=1" ];

      services.desktopManager.plasma6.enable = true;
      services.displayManager.plasma-login-manager.enable = true;

      hardware.asahi.enable = true;
      hardware.bluetooth.enable = true;

      networking = {
        networkmanager.enable = true;
        hostName = "cholla";
        #domain = "homelab.${config.networkDomain}";
        useDHCP = lib.mkDefault true;
      };

      time.timeZone = "Europe/Oslo";

      system.stateVersion = lib.mkDefault "26.05";
    };

  flake.modules.nixos.cholla-hwconfig =
    { modulesPath, ... }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot.initrd.availableKernelModules = [ "usb_storage" ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ ];
      boot.extraModulePackages = [ ];

      fileSystems."/" = {
        device = "/dev/mapper/cryptroot";
        fsType = "btrfs";
        options = [ "subvol=@" ];
      };

      boot.initrd.luks.devices."cryptroot".device =
        "/dev/disk/by-uuid/aaef6f89-f4a9-4832-bf8d-da35660c0aee";

      fileSystems."/home" = {
        device = "/dev/mapper/cryptroot";
        fsType = "btrfs";
        options = [ "subvol=@home" ];
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/A5D5-11EE";
        fsType = "vfat";
        options = [
          "fmask=0022"
          "dmask=0022"
        ];
      };

      swapDevices = [ ];

      nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
    };
}
