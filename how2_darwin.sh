#!/usr/bin/env bash

sudo darwin-rebuild check --flake ~/nix-config/#saguaro

# nix-collect-garbage -d
# nix store gc
