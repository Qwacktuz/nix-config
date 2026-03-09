{ ... }:

{
  flake.modules.homeManager.virtualization =
    { pkgs, ... }:
    {
      services.colima = {
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
