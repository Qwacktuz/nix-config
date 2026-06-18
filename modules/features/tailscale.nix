{ ... }:
{
  flake.modules.darwin.tailscale = {
    # environment.systemPackages = with pkgs; [
    # tsui # check the github for installation instructions
    # ];

    services.tailscale = {
      enable = true;
      #overrideLocalDns = true;
    };
  };

  flake.modules.nixos.tailscale =
    { config, ... }:
    {
      services.tailscale = {
        enable = true;
      };

      networking = {
        nftables.enable = true;
        firewall = {
          enable = true;
          trustedInterfaces = [ "tailscale0" ];
          allowedUDPPorts = [ config.services.tailscale.port ];
        };
      };

      systemd.services.tailscaled.serviceConfig.Environment = [
        "TS_DEBUG_FIREWALL_MODE=nftables"
      ];

      systemd.network.wait-online.enable = false;
      boot.initrd.systemd.network.wait-online.enable = false;
    };
}
