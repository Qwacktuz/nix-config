{
  inputs,
  customConfig,
  config,
  ...
}:
{
  imports = [ inputs.nix-homebrew.darwinModules.nix-homebrew ];

  nix-homebrew = {
    enable = true;
    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = true;
    # User owning the Homebrew prefix
    user = customConfig.username;
    # Automatically migrate existing Homebrew installations
    # autoMigrate = true;

    mutableTaps = true;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "psharma04/homebrew-dorion" = inputs.psharma04-dorion;
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
      "visual-studio-code"
      "signal" # newer build than pkgs.signal-desktop-bin
      "dorion"
      "keepassxc"
      "proton-mail"
      "tuta-mail"
      "steam" # nixpkgs build doesn't support darwin afaik
      "libreoffice"
      "tor-browser"
      "element"
      "orion"
      "helium-browser"
      "wacom-tablet"
      #"vmware-fusion" # Apparently disabled because broadcom
      "virtualbox"
      "hashicorp/tap/hashicorp-vagrant"
      "docker-desktop"
      "burp-suite"
      "omnissa-horizon-client"
      "chatgpt-atlas"
      "font-fontawesome"
      "wireshark-app"
    ];
    brews = [
      "ltex-ls"
      "scrcpy"
      "binwalk"
      "mas"
      "picocom"
    ];
    masApps = {
      "WireGuard" = 1451685025;
      "Tailscale" = 1475387142;
    };

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
