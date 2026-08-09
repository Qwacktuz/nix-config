{
  flake.modules.homeManager.virtualization =
    { pkgs, ... }:
    {
      services.colima.enable = false;

      programs.docker-cli.enable = true;

      home.packages = with pkgs; [
        orbstack
        lima
        lazydocker
        utm
        qemu
      ];
    };
}
