{ pkgs, ... }:
{
  flake.modules.darwin.virtualization = {
    environment.systemPackages = with pkgs; [
      qemu
      utm
    ];
  };
}
