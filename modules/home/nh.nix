{ ... }:
{
  flake.modules.home-manager.nh =
    { pkgs, ... }:
    {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 7d --keep 3";
        };
        flake = "~/nix-config";
      };

      home.packages = with pkgs; [
        nix-output-monitor # nh pretty output
        nvd # nh diffing capability
      ];
    };
}
