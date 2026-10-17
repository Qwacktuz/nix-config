{
  flake.modules.darwin.virtualization.homebrew.casks = [ "orbstack" ];
  flake.modules.darwin.virtualization-vms.homebrew.casks = [ "utm" ];

  flake.modules.homeManager.virtualization = { pkgs, ... }: {
    programs.docker-cli.enable = true;
    home.packages = [ pkgs.lazydocker ];
  };

  flake.modules.homeManager.virtualization-vms = { pkgs, ... }: {
    home.packages = with pkgs; [
      lima
      qemu
    ];
  };
}
