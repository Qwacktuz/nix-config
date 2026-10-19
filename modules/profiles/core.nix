{ config, ... }:
{
  flake.modules.darwin.profile-core = {
    imports = with config.flake.modules.darwin; [
      system-base
      darwin-profile-base
      aerospace
      homebrew
      ghostty
      brave
      spicetify
      yubikey
      stylix
      tailscale
    ];
    home-manager.users.${config.userName}.imports = with config.flake.modules.homeManager; [
      profile-core
      brave
      spicetify
      ssh-private-keys
    ];
    homebrew.casks = [
      "obsidian"
      "localsend"
      "stats"
      "iina"
      "keepassxc"
      "karabiner-elements"
      "lulu"
      "font-fontawesome"
      "chatgpt"
      "signal"
      "proton-pass"
      "protonvpn"
      "tuta-mail"
      "element"
      "legcord"
      "proton-mail"
      "proton-mail-bridge"
      "mos"
      "monitorcontrol"
      "middleclick"
      "linearmouse"
      "vorta"
      "anki"
    ];
    homebrew.brews = [
      "proton-pass-cli"
      "mas"
      "mole"
      "jdupes"
    ];
    homebrew.masApps.WireGuard = 1451685025;
  };

  flake.modules.homeManager.profile-core = { pkgs, lib, ... }: {
    imports = with config.flake.modules.homeManager; [
      profile-cli
      ghostty
      syncthing
      yubikey
    ];
    home.packages =
      (with pkgs; [
        protonmail-export
        docfd
        keepass-diff
        mimeo
        signalbackup-tools
        todo
        tdf
      ])
      ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux (
        builtins.filter (lib.meta.availableOn pkgs.stdenv.hostPlatform) (
          with pkgs;
          [
            qbittorrent
            obsidian
            localsend
            keepassxc
            protonmail-desktop
            protonmail-bridge
            proton-pass
            anki-bin
            deluge
            signal-desktop
            element-desktop
            vorta
            legcord
            jdupes
          ]
        )
      )
      ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ pkgs.qbittorrent ];
  };
  flake.modules.homeManager.profile-cli = { pkgs, ... }: {
    imports = with config.flake.modules.homeManager; [
      dotfiles
      git
      jujutsu
      zsh
      zsh-aliases
      direnv
      starship
      fzf
      bat
      btop
      micro
      fastfetch
      nh
      ssh-client
      sops
      fonts
    ];
    home.packages = with pkgs; [
      eza
      fd
      ripgrep
      gtrash
      tldr
      ncdu
      jq
      file
      wget
      unzip
      xxd
      openssl
      killall
      htop
      man-pages
      hexdump
    ];
  };
}
