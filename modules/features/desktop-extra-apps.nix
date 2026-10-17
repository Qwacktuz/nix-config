{
  flake.modules.homeManager.desktop-extra-apps = { pkgs, lib, ... }: {
    home.packages =
      with pkgs;
      [
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        deluge
        obs-studio
        parsec-bin
        signal-desktop
        keepassxc
        libreoffice
        element-desktop
        burpsuite
        wireshark
        rpi-imager
        vorta
        legcord
        tailscale
      ];
  };
}
