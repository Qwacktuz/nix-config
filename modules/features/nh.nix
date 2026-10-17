{ ... }:
{
  flake.modules.homeManager.nh =
    { pkgs, config, ... }:
    {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 7d --keep 3";
        };

        flake = "${config.home.homeDirectory}/nix-config";
      };

      home.packages = with pkgs; [
        nix-output-monitor
        nvd
      ];
    };
}
