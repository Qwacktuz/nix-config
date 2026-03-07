{
  self,
  config,
  lib,
  ...
}:
{
  flake.modules.nixos.fishhook =
    {
      modulesPath,
      ...
    }:
    {
      imports =
        with self.modules;
        [
          generic.core
          nixos.${config.userName}
          nixos.tailscale
          nixos.ssh-server
        ]
        ++ [
          (modulesPath + "/virtualisation/proxmox-lxc.nix")
        ];

      boot.isContainer = true;

      networking = {
        hostName = "fishhook";
        domain = "homelab.${config.networkDomain}";

        # Make it obey the network
        useDHCP = lib.mkDefault true;
      };

      time.timeZone = "Europe/Oslo";

      services = {
        tailscale = {
          useRoutingFeatures = "server";
          extraSetFlags = [ "--ssh=true" ];
        };

        openssh.settings = {
          AllowTcpForwarding = "yes";
        };
      };

      users.users.${config.userName}.openssh.authorizedKeys.keyFiles = [
        ../../pubkeys/saguaro_id_ed25519.pub
      ];

      system.stateVersion = lib.mkDefault "25.11";

      /*
        # Not used for LXC containers
        xserver.xkb.layout = "us";
        services.qemuGuest.enable = true;
        boot.loader.limine.enable = true;
        fileSystems."/" = {
          device = "/dev/disk/by-label/nixos";
          fsType = "ext4";
        };

        # for EFI
        fileSystems."/boot" = {
          device = "/dev/disk/by-label/boot";
          fsType = "vfat";
        };
      */
    };
}
