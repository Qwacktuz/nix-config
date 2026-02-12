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

        flake = lib.mkDefault (
          if pkgs.stdenvNoCC.isDarwin then "/Users/${config.userName}" else "/home/${config.userName}"
        );
      };

      home.packages = with pkgs; [
        nix-output-monitor
        nvd
      ];
    };
}
