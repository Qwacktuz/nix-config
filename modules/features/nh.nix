{ ... }:
{
  flake.modules.homeManager.nh =
    { pkgs, config, ... }:
    {
      programs.nh = {
        enable = true;
        clean = {
          # Determinate Nixd handles garbage collection on our Darwin hosts.
          enable = pkgs.stdenv.hostPlatform.isLinux;
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
