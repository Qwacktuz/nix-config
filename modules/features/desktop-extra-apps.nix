{
  flake.modules.homeManager.desktop-extra-apps = { pkgs, lib, ... }: {
    home.packages = lib.optionals pkgs.stdenv.hostPlatform.isLinux (
      with pkgs;
      [
        qbittorrent
        xournalpp
        remmina
        protonmail-desktop
        protonmail-bridge
        proton-pass
        anki-bin
        deluge
        obs-studio
        parsec-bin
        signal-desktop
        libreoffice
        element-desktop
        burpsuite
        wireshark
        rpi-imager
        vorta
        legcord
      ]
    );
  };
}
