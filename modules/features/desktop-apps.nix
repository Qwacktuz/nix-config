{
  flake.modules.homeManager.desktop-apps = { pkgs, lib, ... }: {
    home.packages = with pkgs; [
      obsidian
      localsend
      qbittorrent
      xournalpp
      remmina
      protonmail-desktop
      protonmail-bridge
      proton-pass
      mpv
      tenacity
      anki-bin
    ];
  };
}
