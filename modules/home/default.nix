{ ... }:
{
  imports = [
    ./packages.nix

    # Shell
    ./starship.nix
    ./zsh.nix
    ./zsh_alias.nix

    # Services (might be enabled as darwin modules instead of HM)
    ./syncthing.nix
    # ./music.nix
    # ./aerospace.nix
    # ./sketchybar.nix
    # ./skhd.nix

    # GUI
    # GTK+3 issue upstream (sincos) https://github.com/NixOS/nixpkgs/pull/449689
    # ./zen-browser.nix
    ./vesktop.nix
    ./vscodium.nix # Using vscodium-system.nix
    ./spicetify.nix

    # TUI/CLI
    ./git.nix
    ./nh.nix
    ./micro.nix
    ./fzf.nix
    ./btop.nix
    ./bat.nix
    ./fastfetch.nix
  ];
}
