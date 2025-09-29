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
    autoMigrate = true;

    mutableTaps = true;
    taps = {
      "homebrew/homebrew-core" = inputs.homebrew-core;
      # "homebrew/homebrew-cask" = inputs.homebrew-cask;
      "psharma04/homebrew-dorion" = inputs.psharma04-dorion;
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
      "ghostty"
      "signal" # newer build than pkgs.signal-desktop-bin
      "dorion"
      "keepassxc"
      "steam" # nixpkgs build doesn't support darwin afaik
      "libreoffice"
      "tor-browser"
      "element"
      "orion"
      "helium-browser"
      "wacom-tablet"
      #"vmware-fusion" # Apparently disabled because broadcom
      "hashicorp/tap/hashicorp-vagrant"
    ];
    brews = [
      "binwalk"
    ];

    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };
}
