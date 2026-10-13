{ self, config, ... }:
{
  flake.modules.darwin.saguaro = {
    imports = with config.flake.modules.darwin; [
      profile-desktop
      config.flake.modules.darwin.${config.userName}
      # darwin.virtualization
      # darwin.karabiner
      # darwin.sketchybar
      # darwin.sops
    ];

    networking.hostName = "saguaro";

    nixpkgs.overlays = [
      self.overlays.default
      self.overlays.spotify
    ];

    # Disable when using determinate nix
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
