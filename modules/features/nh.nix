{ config, ... }:
{
  flake.modules.homeManager.nh =
    { pkgs, ... }:
    {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 7d --keep 3";
        };

        flake = "/Users/${config.userName}/nix-config";
      };

      home.packages = with pkgs; [
        nix-output-monitor
        nvd
      ];
    };
}
