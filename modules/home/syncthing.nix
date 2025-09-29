{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    syncthingtray
    syncthing-macos
  ];
  services.syncthing = {
    enable = true;
  };
}
