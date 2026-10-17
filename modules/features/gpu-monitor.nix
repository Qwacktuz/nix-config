{
  flake.modules.homeManager.gpu-monitor = { pkgs, lib, ... }: {
    home.packages =
      lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.nvtopPackages.apple ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [ pkgs.nvtopPackages.full ];
  };
}
