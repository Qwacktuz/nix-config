{
  flake.modules.homeManager.desktop-extra-apps =
    { pkgs, lib, ... }:
    let
      candidates = lib.optionals pkgs.stdenv.hostPlatform.isLinux (
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
      available = lib.meta.availableOn pkgs.stdenv.hostPlatform;
      unavailable = builtins.filter (p: !available p) candidates;
    in
    {
      # These casks are disabled on macOS in the pinned Homebrew input.
      home.packages =
        builtins.filter available candidates
        ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin (
          with pkgs;
          [
            qbittorrent
            xournalpp
          ]
        );
      warnings =
        lib.optional (unavailable != [ ])
          "Optional desktop apps unavailable on ${pkgs.stdenv.hostPlatform.system}: ${
            lib.concatMapStringsSep ", " lib.getName unavailable
          }";
    };
}
