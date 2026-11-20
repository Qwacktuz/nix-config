#!/usr/bin/env bash
# Regenerate, format, check and switch the current host.
# Does not update input pins (use `nix flake update` for that).

set -euo pipefail

# Run from the flake root, wherever the repo is cloned.
cd "$(dirname "${BASH_SOURCE[0]}")"

case "$(uname -s)" in
Darwin) platform=darwin ;;
Linux) platform=os ;;
*)
  echo "Unsupported OS: $(uname -s)" >&2
  exit 1
  ;;
esac

# Regenerate first so format and check see the real flake.nix.
echo "Regenerating flake.nix..."
nix shell nixpkgs#coreutils --command nix run .#write-flake

echo "Formatting..."
nix fmt

echo "Checking flake..."
nix flake check

# nh picks the configuration matching this machine's hostname.
echo "Switching $(hostname -s)..."
nh "$platform" switch .

read -rp "Collect garbage? (y/n): " answer
if [[ $answer =~ ^[Yy]$ ]]; then
  echo "Collecting garbage..."
  nh clean all
  nix store optimise

  if [[ $platform == darwin ]] && command -v mo &>/dev/null; then
    echo "Running Mole cleanup..."
    mo clean
    mo optimize
  fi
else
  echo "Skipping garbage collection."
fi
