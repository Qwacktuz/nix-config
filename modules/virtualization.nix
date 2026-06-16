{ ... }:

{
  flake.modules.homeManager.virtualization =
    { pkgs, ... }:
    {
      services.colima = {
        enable = false;
      };

      programs.docker-cli = {
        enable = true;
      };

      home.packages = with pkgs; [
        orbstack # Docker Desktop replacement
        lima # Run linux VMs
        lazydocker
        utm # Virtual machines
        qemu
      ];
    };
}
