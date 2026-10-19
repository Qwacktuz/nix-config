{
  # Tenacity has no cask; mpv's Brew dependency graph fails with the pinned taps.
  flake.modules.homeManager.creative-apps = { pkgs, ... }: {
    home.packages = with pkgs; [
      tenacity
      mpv
    ];
  };
}
