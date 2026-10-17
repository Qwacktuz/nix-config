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
        onActivation.cleanup = "none";
        onActivation.autoUpdate = false;
        onActivation.upgrade = false;
      };
    };
}
