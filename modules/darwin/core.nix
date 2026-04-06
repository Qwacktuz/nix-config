{
  self,
  config,
  lib,
  ...
}:
{
  flake.modules.darwin.core = {
    imports = with self.modules; [
      generic.core
      darwin.mac-settings
      darwin.${config.userName}
    ];

    nixpkgs.overlays = [
      self.overlays.default
      self.overlays.spotify
    ];

    # Use determinate nix
    nix.enable = false;

    # Small VM that builds x86_64-linux systems anywhere!
    # Might move to darwin module
    #nix.settings.extra-platforms = [
    #  "aarch64-linux"
    #  "x86_64-linux"
    #];

    #nix.settings.trusted-users = [ "@admin" ];
    # nix.linux-builder = {
    #   systems = [
    #     "aarch64-linux"
    #     "x86_64-linux"
    #   ];
    #   enable = lib.mkDefault true;
    #   ephemeral = true;
    #   config = {
    #     boot.binfmt.emulatedSystems = [ "x86_64-linux" ];
    #     virtualisation = {
    #       darwin-builder = {
    #         diskSize = 25 * 1024;
    #         memorySize = 6 * 1024;
    #       };
    #       cores = 2;
    #     };
    #   };
    #};
  };
}
