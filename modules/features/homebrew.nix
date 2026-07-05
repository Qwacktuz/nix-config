{ inputs, config, ... }:
let
  inherit (config) userName;
in

{
  flake-file.inputs.nix-homebrew.url = "github:zhaofengli/nix-homebrew";

  flake.modules.darwin.homebrew =
    { config, lib, ... }:
    {
      imports = lib.optionals (inputs ? nix-homebrew) [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

      nix-homebrew = {
        enable = true;
        user = userName; # User owning the Homebrew prefix
        autoMigrate = true; # Let nix symlink existing installations etc.

        # Alternative set this under git.nix if mutableTaps = true;
        # git config --global --add safe.directory '/nix/store/*'
        # programs.git.extraConfig.safe.directory = "/nix/store/*";
        mutableTaps = false;
        taps = {
          "homebrew/homebrew-core" = inputs.homebrew-core;
          "homebrew/homebrew-cask" = inputs.homebrew-cask;
          "tw93/homebrew-mole" = inputs.tw93-mole;
          "hashicorp/homebrew-tap" = inputs.hashicorp-tap;
        };
      };

      homebrew = {
        taps = builtins.attrNames config.nix-homebrew.taps;
        enable = true;
        casks = [
          "mos"
          "monitorcontrol"
          "obs"
          "parsec"
          "nvidia-geforce-now"
          "karabiner-elements"
          "ghostty"
          # "little-snitch" # amazing, but expensive + memory intensive
          "lulu" # FOSS little snitch alternative
          "android-studio"
          "void"
          "signal" # newer build than pkgs.signal-desktop-bin
          "keepassxc"
          "proton-mail"
          # "protonvpn"
          "tuta-mail"
          "steam" # nixpkgs build doesn't support darwin afaik
          "libreoffice"
          "tor-browser"
          "element"
          "yubico-authenticator"
          "orion"
          "helium-browser"
          "wacom-tablet"
          # "vmware-fusion" # Apparently disabled because broadcom
          "hashicorp/tap/hashicorp-vagrant"
          "burp-suite"
          "omnissa-horizon-client"
          "chatgpt-atlas"
          "font-fontawesome"
          "wireshark-app"
          "codex-app"
          "warp"
          "detexify"
          "middleclick"
          "1kc-razer"
          "raspberry-pi-imager"
          "vorta"
          "linearmouse"
          "bit-slicer"
          "legcord"
          "tailscale"
        ];
        brews = [
          "mole"
          # "ltex-ls"
          "scrcpy"
          "binwalk"
          "mas"
          "picocom"
          "jdupes"
        ];
        masApps = {
          "WireGuard" = 1451685025;
          # "Tailscale" = 1475387142;
          # "Xcode" = 497799835;
        };

        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };
    };
}
