{ pkgs, customConfig, ... }:
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--keep-since 7d --keep 5";
    };
    # TODO: generalize for linux & darwin systems
    flake = "/User/${customConfig.username}/nixos-config";
  };

  home.packages = with pkgs; [
    nix-output-monitor
    nvd
  ];
}
