{ pkgs, ... }:
{
  # environment.systemPackages = with pkgs; [
  # tsui # check the github for installation instructions
  # ];

  services.tailscale = {
    enable = true;
    #overrideLocalDns = true;
  };
}
