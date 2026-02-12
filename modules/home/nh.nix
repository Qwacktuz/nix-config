{ ... }:
{
  flake.homeModules.nh =
    { self, pkgs, ... }:
    {
      programs.nh = {
        enable = true;
        clean = {
          enable = true;
          extraArgs = "--keep-since 7d --keep 3";
        };
        flake = "${self}";
      };

      home.packages = with pkgs; [
        nix-output-monitor # nh pretty output
        nvd # nh diffing capability
      ];
    };
}
