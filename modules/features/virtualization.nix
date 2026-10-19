{
  flake.modules.darwin.virtualization.homebrew.casks = [ "orbstack" ];
  flake.modules.darwin.virtualization-vms.homebrew.casks = [ "utm" ];

  flake.modules.homeManager.virtualization = { pkgs, ... }: {
    # OrbStack and docker login/context commands need a writable config on macOS.
    programs.docker-cli.enable = pkgs.stdenv.hostPlatform.isLinux;
    home.packages = [ pkgs.lazydocker ];
  };

  flake.modules.homeManager.virtualization-vms = { pkgs, ... }: {
    home.packages = with pkgs; [
      lima
      qemu
    ];
  };
}
