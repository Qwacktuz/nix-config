{
  self,
  config,
  lib,
  ...
}:
{
  flake.modules.nixos.fishhook = {
    imports = with self.modules; [
      generic.core
      nixos.${config.userName}
      nixos.tailscale
      nixos.ssh-server
    ];

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

    networking = {
      hostName = "fishhook";
      domain = "homelab.${config.networkDomain}";
    };

    time.timeZone = "Europe/Oslo";

    services = {
      xserver.xkb.layout = "us";
      tailscale = {
        useRoutingFeatures = "server";
        extraSetFlags = [ "--ssh=true" ];
      };

      qemuGuest.enable = true;
      openssh.settings = {
        AllowTcpForwarding = "yes";
      };
    };

    users.users.${config.userName}.openssh.authorizedKeys.keyFiles = [
      ../../pubkeys/saguaro_id_ed25519.pub
    ];

    system.stateVersion = lib.mkDefault "25.11";
  };
}
