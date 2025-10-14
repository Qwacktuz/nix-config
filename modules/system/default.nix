{ ... }:
{
  imports = [
    ./homebrew.nix
    ./stylix.nix

    # nix-darwin services
    # ./sketchybar.nix
    ./aerospace.nix
    ./tailscale.nix
  ];
}
