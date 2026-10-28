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
        onActivation.cleanup = "uninstall";
        onActivation.autoUpdate = false;
        onActivation.upgrade = false;
      };
    };
}
