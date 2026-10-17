{
  flake.modules.homeManager.btop =
    { pkgs, lib, ... }:
    {
      programs.btop = {
        enable = true;

        settings = {
          update_ms = 500;
          rounded_corners = true;
        };
      };

      home.packages =
        lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.nvtopPackages.apple ]
        ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.nvtopPackages.full ];
    };
}
