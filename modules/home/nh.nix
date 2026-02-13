{ ... }:
{
  flake.modules.homeManager.nh =
    {
      config,
      pkgs,
      lib,
      ...
    }:
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
