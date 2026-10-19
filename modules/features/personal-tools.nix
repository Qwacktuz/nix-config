{
  flake.modules.homeManager.personal-tools = { pkgs, lib, ... }: {
    home.packages =
      with pkgs;
      [
        protonmail-export
        (ani-cli.override { withMpv = !pkgs.stdenv.hostPlatform.isDarwin; })
        aoc-cli
        binsider
        bitwise
        docfd
        entr
        ffmpeg
        gifsicle
        imagemagick
        keepass-diff
        mermaid-cli
        mimeo
        signalbackup-tools
        todo
        tdf
        toipe
        ttyper
        viu
        picocom
        cbonsai
        cmatrix
        kittysay
        neo-cowsay
        iperf3
        socat
        smartmontools
        iftop
      ]
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
        sysdig
        scrcpy
        binwalk
        jdupes
        hieroglyphic
      ];
  };
}
