{ pkgs, config, ... }:
let
  commonPackages = with pkgs; [
    neovim
    curl
    git
    zip
    devenv
  ];
  debugger = if pkgs.stdenv.isDarwin then "lldb" else "gdb";
  memcheck = if pkgs.stdenv.isLinux then "valgrind --leak-check=full" else "leaks --atExit --";
in
{
  # Default Shell Configuration
  # This is what the `devenv` CLI and `direnv` will load by default.
  name = "nix-dev";

  packages = commonPackages;

  enterShell = ''
    echo "❄️ Nix devshell loaded | 'napply' to rebuild | 'nfmt' to format | 'ncheck' to lint"
  '';

  scripts.napply.exec = "nh darwin switch .#saguaro";
  # We use the generic 'treefmt' command here; the flake integration will 
  # provide the specific wrapper when loaded via 'nix develop' or 'use flake'.
  scripts.nfmt.exec = "treefmt";
  scripts.ncheck.exec = "nix flake check";

  # C Development Environment
  # Note: To use this via the CLI, you'd typically use `devenv shell c`
  languages.c.enable = true;

  # We can't easily define multiple top-level shells in a single devenv.nix 
  # for the CLI, so we keep the C-specific tools here.
  # When loaded via Flake, the 'c' shell will inherit these.
  # scripts.cb.exec = "cc -Wall -Wextra -g $1 -o out";
  # scripts.cx.exec = "cc -Wall -Wextra -g $1 -o out && ./out";
}
