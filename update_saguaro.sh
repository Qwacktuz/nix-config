#!/usr/bin/env bash

set -e

# Go to flake.nix root directory
cd "$HOME"/nix-config/ || exit

# Formatting with nixfmt (can also use nfmt for treefmt)
echo "Formatting with nixfmt..."
find . -name '*.nix' -exec nixfmt {} +

# Lint/check for syntax errors (ncheck)
echo "Checking flake syntax..."
nix flake check --all-systems

# Update flake file and inputs
echo "Updating flake inputs..."
nix run .#write-flake

# Sanity check
# sudo -H darwin-rebuild check --flake ~/nix-config#saguaro

# Apply the update
echo "Applying the update..."
nh darwin switch ~/nix-config/ --hostname saguaro

# Garbage collection (optional)
read -rp "Do you want to collect the trash? (y/n): " answer
if [[ $answer =~ ^[Yy]$ ]]; then
  echo "Starting garbage collection"
  #nix store gc
  #nix-collect-garbage -d
  nh clean all
  mo clean # MacOS only!
else
  echo "Garbage wont be collected"
fi
