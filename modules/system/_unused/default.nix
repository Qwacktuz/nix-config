{ ... }:
{
  imports = [
    ./homebrew.nix
    ./stylix.nix
    # TODO: fix sops
    # ./sops.nix

    # nix-darwin services
    # ./sketchybar.nix
    ./aerospace.nix
    # ./karabiner.nix

    # macos issues, idk, just enable the mas app
    # ./tailscale.nix
  ];
}
