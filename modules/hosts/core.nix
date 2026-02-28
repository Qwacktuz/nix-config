{ self, ... }:
{
  flake.modules.generic.core =
    { pkgs, lib, ... }:
    {
      # host level configs
      nixpkgs.config.allowUnfree = lib.mkDefault true;
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Small VM that builds x86_64-linux systems anywhere!
      # Might move to darwin module
      nix.linux-builder.enable = lib.mkDefault true;

      # Move to darwin core module?
      nixpkgs.overlays = [
        self.overlays.default
        self.overlays.spotify
      ];

      fonts = {
        packages = with pkgs; [ nerd-fonts.jetbrains-mono ];
      };

      # openssh.authorizedKeys.keys = [
      #   (builtins.readFile ./pubkeys/saguaro_id_ed25519.pub)
      # ];
    };
}
