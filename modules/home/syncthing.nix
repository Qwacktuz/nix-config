{ pkgs, ... }:
{
  # environment.systemPackages = with pkgs; [
  #   syncthing-macos
  # ];
  services.syncthing = {
    enable = true;
    package = pkgs.syncthing-macos;
  };
}
