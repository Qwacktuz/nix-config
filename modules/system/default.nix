{ ... }:
{
  imports = [
    ./homebrew.nix
    ./stylix.nix
    ./llm.nix

    # nix-darwin services
    ./sketchybar.nix
    ./aerospace.nix
    # ./tailscale.nix
  ];
}
