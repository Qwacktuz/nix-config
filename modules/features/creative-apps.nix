{
  # Tenacity has no matching cask in the pinned input; keep it opt-in via Nix.
  flake.modules.homeManager.creative-apps = { pkgs, ... }: {
    home.packages = with pkgs; [
      tenacity
      mpv
    ];
  };
}
