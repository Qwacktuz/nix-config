{ pkgs, ... }:
{
  # Works on aarch64-darwin + x86_64-linux
  home.packages = with pkgs; [
    # GUI Apps
    #neovim # program.enabled
    obsidian
    localsend
    deluge
    #ghostty # broken on darwin

    # TODO: configure alternative browsers (DRY if ff based)
    # librewolf # DRY-able
    # mullvad-vpn # darwin build not working

    # Devtools
    jetbrains.pycharm-professional
    jetbrains.idea-ultimate
    jetbrains.goland
    pnpm
    utm
    # vagrant # installed with brew because brew package is more recent
    podman
    docker
    # audacity

    brave
    qbittorrent
    zathura # typst deps
    websocat # typst deps

    # Hax
    exiftool
    nmap
    inetutils
    john
    # burpsuite # some error iirc
    wireshark
    # binwalk # doesn't work with some kind of font dep not working

    # Gaming
    osu-lazer-bin
    prismlauncher

    # CLI
    #zoxide # program.enabled
    #btop # program.enabled
    #bat # program.enabled
    #fastfetch # program.enabled
    #fzf # neovim depenency & program.enabled
    cmatrix
    cbonsai
    sl
    kittysay
    neo-cowsay

    # Programming support
    go
    cargo
    rustc
    #rustup # package manager for cargo ??
    python314
    typescript
    temurin-bin
    kotlin
    lua # neovim depenency
    luarocks # neovim depenency
    zig
    nix-diff
    typst # need the entire toolchain
    typship # typst package CLI tool

    # Resource monitoring
    iftop # Network
    htop # lightweight
    nvtopPackages.apple # GPU
    sysdig # dig into processes (iotop+)
    asitop # Activity Monitor replacement
    # atop # core metrics + hidden metrics
    # s-tui # Stresstest (CPU)
    # iotop # disk io
    # btop # flex-top lmao
    # perf-linux # go deeper
    # earavemon

    ani-cli # view anime in the terminal
    aoc-cli # Advent of Code command-line tool
    binsider # Analyze ELF binaries
    bitwise # cli tool for bit / hex manipulation
    caligula # User-friendly, lightweight TUI for disk imaging
    docfd # TUI multiline fuzzy document finder
    eza # ls replacement
    entr # perform action when file change
    fd # find replacement & neovim depenency
    ffmpeg
    file # Show file information
    gcc # neovim depenency
    gifsicle # gif utility
    git # neovim depenency
    ghostscript # neovim depenency
    gtrash # rm replacement, put deleted files in system trash
    hexdump
    iina # ani-cli depenency
    imagemagick # image editor & neovim depenency
    jq # JSON processor
    keepass-diff # diff .kdbx files
    killall
    lazygit # neovim depenency
    man-pages # extra man pages
    mermaid-cli # neovim depenency
    mimeo # convert JSON/CSV/YAML-type files to differnt outputs
    ncdu # disk space
    nixd # nix lsp
    nil # nix lsp
    nixfmt-rfc-style # nix formatter
    nixpkgs-fmt # nix formatter (nixpkgs sytle)
    nodejs # neovim depenency
    openssl
    onefetch # fetch utility for git repo
    programmer-calculator
    ripgrep # grep replacement & neovim depenency
    shfmt # bash formatter
    tdf # cli pdf viewer
    tectonic # neovim depenency
    texliveSmall # neovim depenency
    tldr # summarize commands
    todo # cli todo list
    toipe # typing test in the terminal
    treefmt # project formatter
    tree-sitter # neovim depenency
    ttyper # cli typing test
    unzip
    viu # TUI image viewer
    wget
    yt-dlp-light
    xxd
  ];
}
