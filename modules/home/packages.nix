{ ... }:
{
  # packages.nix: General packages available across systems.
  # For Darwin-specific packages, see `darwin-packages.nix`.
  flake.modules.homeManager.packages =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [

        #=======================================================================
        # GUI Applications
        #================================_======================================
        obsidian
        localsend
        deluge
        brave
        qbittorrent
        xournalpp
        notion-app # Note taking app
        # pika-backup
        # unifi

        #=======================================================================
        # Developer Tools
        #=======================================================================

        # Languages & Runtimes
        go
        golangci-lint
        golangci-lint-langserver
        zig
        cargo
        rustc
        temurin-bin # Java runtime
        kotlin
        gradle
        python315
        pixi # Python/uv replacement
        typescript
        bun
        deno
        pnpm

        # DevOps & Containers
        lazysql
        lazyjournal
        android-tools
        xcodes
        act # Run GitHub Actions locally
        yq # YAML processor
        kubectx # Kubernetes context switching
        infisical # secrets management
        tenv # install opentofu through this
        ansible
        fluxcd
        awscli2

        # Nix Ecosystem
        nil # Nix Language Server (LSP)
        nixfmt # Formatter
        devenv # Development environments
        sops # For editing secrets
        age # Encryption needed for sops
        ssh-to-age # Helper for sops keys
        statix # Linter for Nix
        nix-diff

        # General Dev Tools
        typst # Document creation
        typship # typst package CLI tool
        typstPackages.fontawesome
        zed # Code editor
        mpv # Media player
        tenacity # Audio editor
        glow # cli markdown viewer
        just # make alternative
        watchexec # exec commands on filechange
        iperf3

        #=======================================================================
        # Security & Pentesting (Hax)
        #=======================================================================
        # openssh
        shadowsocks-rust
        exiftool
        nmap
        inetutils
        # john # Password cracker
        # steghide
        zsteg
        hexedit
        scalpel
        foremost
        trivy # Vulnerability scanner
        tfsec # Terraform static analysis
        syft # Generate SBOM
        grype # Vulnerability scanner for SBOM
        yubico-piv-tool
        yubikey-manager
        opensc
        # hcxtools

        #=======================================================================
        # System & Resource Monitoring
        #=======================================================================
        iftop # Network traffic
        htop # Process monitor
        nvtopPackages.apple # GPU monitor
        sysdig # System-level monitoring
        macpm # Activity Monitor replacement for Mac
        ncdu # Disk space analyzer

        #=======================================================================
        # CLI Utilities
        #=======================================================================
        eza # `ls` replacement
        fd # `find` replacement
        ripgrep # `grep` replacement
        gtrash # `rm` replacement
        bat # `cat` replacement with syntax highlighting
        fzf # Fuzzy finder
        zoxide # Smarter `cd`
        tldr # Simplified man pages
        treefmt # Project formatter
        shfmt # Shell formatter
        jq # JSON processor
        ani-cli # Watch anime
        anki-bin # Flashcards
        aoc-cli # Advent of Code CLI
        # baobab # Disk usage analyzer
        binsider # Analyze ELF binaries
        bitwise # Bit/hex manipulation
        caligula # Disk imaging
        docfd # Fuzzy document finder
        entr # Run command on file change
        ffmpeg
        file # Show file information
        gifsicle # GIF utility
        hexdump
        imagemagick # Image manipulation
        keepass-diff # Diff .kdbx files
        killall
        languagetool
        lazygit # Git TUI
        man-pages
        mermaid-cli # Diagram generation
        mimeo # File format converter
        onefetch # Git repo info
        openssl
        sl # Steam Locomotive
        tdf # PDF viewer
        todo # Todo list
        toipe # Typing test
        ttyper # Typing test
        unzip
        viu # Image viewer
        wget
        # yt-dlp-light
        xxd # hex editor

        patchelf # clion with plugins needs this DEP

        # Fun
        cbonsai
        cmatrix
        kittysay
        neo-cowsay

        #=======================================================================
        # Neovim & Editor Dependencies
        #=======================================================================
        nodejs
        lua5_1
        luarocks
        gcc
        ghostscript
        tectonic
        texliveSmall
        tree-sitter
      ];
    };
}
