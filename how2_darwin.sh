#!/usr/bin/env bash

sudo darwin-rebuild switch --flake ~/nix-config/#saguaro

# nix-collect-garbage -d
# nix store gc
