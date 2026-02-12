#!/usr/bin/env bash

sudo darwin-rebuild switch --flake ~/nix#saguaro

# nix-collect-garbage -d
# nix store gc
