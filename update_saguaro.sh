#!/usr/bin/env bash

set -e

# Go to flake.nix root directory
cd "$HOME"/nix-config/ || exit

# Formatting with nixfmt (can also use nfmt for treefmt)
echo "Formatting with nixfmt..."
nix fmt

# Lint/check for syntax errors (ncheck)
echo "Checking flake syntax..."
nix flake check --all-systems

# Regenerate flake.nix from the module declarations (does not update inputs).
echo "Regenerating flake.nix..."
nix run .#write-flake

# Apply the update
echo "Applying the update..."
nh darwin switch ~/nix-config/ --hostname saguaro

# Garbage collection (optional)
read -rp "Do you want to collect the trash? (y/n): " answer
if [[ $answer =~ ^[Yy]$ ]]; then
  echo "Starting garbage collection"
  nh clean all
  nix store optimise

  if command -v mo &>/dev/null; then
    echo "Starting macOS system cleanup with Mole..."
    mo clean
    mo optimize
  else
    echo "Mole (mo) not found. Cleanup finished!"
  fi
else
  echo "Garbage wont be collected"
fi
