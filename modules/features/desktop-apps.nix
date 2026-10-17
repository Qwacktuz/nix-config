{
  flake.modules.darwin.desktop-apps.homebrew.casks = [
    "obsidian"
    "localsend"
    "qbittorrent"
    "xournal++"
    "proton-mail"
    "proton-mail-bridge"
    "proton-pass"
    "anki"
    "stats"
    "iina"
  ];

  flake.modules.homeManager.desktop-apps = { pkgs, lib, ... }: {
    home.packages = [
      pkgs.mpv
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.tenacity ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (
      with pkgs;
      [
        obsidian
        localsend
        qbittorrent
        xournalpp
        remmina
        protonmail-desktop
        protonmail-bridge
        proton-pass
        tenacity
        anki-bin
      ]
    );
  };
}
