{ config, ... }:
{
  flake.modules.darwin.profile-security = {
    home-manager.users.${config.userName}.imports = [
      config.flake.modules.homeManager.profile-security
    ];
    homebrew.casks = [
      "burp-suite"
      "wireshark-app"
      "bit-slicer"
    ];
    homebrew.brews = [
      "binwalk"
    ];
  };

  flake.modules.homeManager.profile-security = { pkgs, lib, ... }: {
    home.packages =
      (with pkgs; [
        shadowsocks-rust
        exiftool
        nmap
        inetutils
        zsteg
        hexedit
        scalpel
        foremost
        trivy
        tfsec
        syft
        grype
        binsider
        bitwise
        iperf3
        socat
        smartmontools
        iftop
      ])
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (
        builtins.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) (
          with pkgs;
          [
            burpsuite
            wireshark
            sysdig
            binwalk
          ]
        )
      );
  };
}
