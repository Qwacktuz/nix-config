{ pkgs, ... }:
{
  # Works on aarch64-darwin + x86_64-linux
  home.packages = with pkgs; [
    # Devtools
    typst # need the entire toolchain
    typship # typst package CLI tool
    typstPackages.fontawesome
    tenv
    gemini-cli-bin
    codex
    antigravity
    jetbrains.idea
    jetbrains.pycharm
    jetbrains.webstorm
    jetbrains.goland
    jetbrains.clion
    #jetbrains.rust-rover
    zed
    mpv
    tenacity
    pnpm
    utm
    # vagrant # installed with brew because brew package is more recent
    # Podman runs in a VM on macos, no root access (compared to linux)
    # podman
    # podman-tui
    devenv
    orbstack # docker desktop replacement
    # docker
    lazydocker
    lazysql
    lazyjournal
    postman
    android-tools
    xcodes
    # scrcpy # only homebrew package works rn
    # Using nix shells instead
    # devcontainer # cli tool for implementing devcontainers (ex. gh actions)
    # devpod
    # devpod-desktop
    # MOVE TO DEVCONTAINERS
    go
    zig
    cargo
    rustc
    #rustup # package manager for cargo ??
    temurin-bin
    kotlin
    gradle
    python315 # currently managed through .venv and local interpreter through uv
    pixi # uv replacement
    typescript
    bun
    deno
    #lua # neovim depenency

    # Hax
    # https://github.com/azuwis/nix-config/blob/master/darwin/shadowsocks/default.nix
    shadowsocks-rust # TODO: implement this as a nix file
    exiftool
    nmap
    inetutils
    john
    steghide
    zsteg
    # burpsuite # some error iirc
    # wireshark
    # binwalk # doesn't work with some kind of font dep not working

    # TODO: https://github.com/pfassina/lazyvim-nix?tab=readme-ov-file
    # Dependencies
    nodejs # neovim depenency
    lua5_1 # neovim versioned dep
    luarocks # neovim depenency
    zathura # typst deps
    websocat # typst deps

    # GUI Apps
    #neovim # program.enabled
    obsidian
    localsend
    deluge
    notion-app
    #ghostty # broken on darwin
    # librewolf # DRY-able
    # mullvad-vpn # darwin build not working
    # audacity # wait for 4.0
    brave
    qbittorrent
    xournalpp
    notion-app # note taking app

    # Gaming
    osu-lazer-bin

    # Resource monitoring
    iftop # Network
    htop # lightweight
    nvtopPackages.apple # GPU
    sysdig # dig into processes (iotop+)
    macpm # Activity Monitor replacement
    # atop # core metrics + hidden metrics
    # s-tui # Stresstest (CPU)
    # iotop # disk io
    # btop # flex-top lmao
    # perf-linux # go deeper
    # earavemon

    # CLI
    #zoxide # program.enabled
    #btop # program.enabled
    #bat # program.enabled
    #fastfetch # program.enabled
    #fzf # neovim depenency & program.enabled

    ani-cli # view anime in the terminal
    anki-bin # flashcard software
    aoc-cli # Advent of Code command-line tool
    baobab
    binsider # Analyze ELF binaries
    bitwise # cli tool for bit / hex manipulation
    caligula # User-friendly, lightweight TUI for disk imaging
    cbonsai
    cmatrix
    docfd # TUI multiline fuzzy document finder
    eza # ls replacement
    entr # perform action when file change
    fd # find replacement & neovim depenency
    ffmpeg
    file # Show file information
    gcc # neovim depenency
    gifsicle # gif utility
    ghostscript # neovim depenency
    gtrash # rm replacement, put deleted files in system trash
    hexdump
    iina # ani-cli depenency
    imagemagick # image editor & neovim depenency
    jq # JSON processor
    keepass-diff # diff .kdbx files
    kittysay
    killall
    languagetool
    lazygit # neovim depenency
    man-pages # extra man pages
    mermaid-cli # neovim depenency
    mimeo # convert JSON/CSV/YAML-type files to differnt outputs
    ncdu # disk space
    neo-cowsay

    nil # Nix Language Server (LSP)
    #nixd # nix lsp
    nixfmt # Formatter
    #nixpkgs-fmt # Formatter
    sops # For editing your secrets
    age # Encryption needed for sops
    ssh-to-age # Helper for sops keys
    statix # Linter for Nix
    nix-diff
    shfmt # bash formatter

    openssl
    onefetch # fetch utility for git repo
    # programmer-calculator
    ripgrep # grep replacement & neovim depenency
    sl
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
