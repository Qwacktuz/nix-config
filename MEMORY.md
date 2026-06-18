# Repository Memory

This repository is a personal Nix flake for macOS and Linux systems. The flake entrypoint remains small: `flake.nix` calls `inputs.flake-parts.lib.mkFlake` over `inputs.import-tree ./modules`, so every `.nix` file under `modules/` is expected to be an inline flake-parts module unless it is under an ignored `/_` path.

## Current Structure

- `modules/flake/`: global flake-parts wiring for inputs, metadata, nixpkgs/perSystem setup, devshells, and public module aliases.
- `modules/hosts/`: concrete host modules and host output constructors.
- `modules/hardware/`: host-specific hardware or machine-specific NixOS modules.
- `modules/features/`: reusable Home Manager, NixOS, and nix-darwin features registered under `flake.modules.<class>.<name>`.
- `modules/profiles/`: bundles of features for home, NixOS, and Darwin roles.
- `modules/users/`: user account and Home Manager composition for `kaktus`.
- `assets/`: static assets such as wallpapers.
- `archive/unused-modules/`: old unused modules moved out of the recursive import tree.
- `dotfiles/`, `secrets/`, and `pubkeys/`: external data consumed by modules, not flake-parts modules.

## Hosts

- `saguaro`: `aarch64-darwin` nix-darwin host. Imports `darwin.profile-desktop` and the Darwin `kaktus` user composition.
- `cholla`: `aarch64-linux` NixOS/Asahi host. Imports `nixos.profile-desktop`, `nixos.hardware-cholla`, and `nixos.user-kaktus-desktop`.
- `fishhook`: `x86_64-linux` NixOS Proxmox LXC target. Imports `nixos.profile-server` and `nixos.user-kaktus-server`.

Host output construction lives in `modules/hosts/targets.nix`, which defines `darwinConfigurations.saguaro`, `nixosConfigurations.cholla`, and `nixosConfigurations.fishhook`.

## Module Registry

Public aliases are exposed from `modules/flake/module-aliases.nix`:

- `homeManagerModules = config.flake.modules.homeManager`
- `nixosModules = config.flake.modules.nixos`
- `darwinModules = config.flake.modules.darwin`

Important profiles:

- Home Manager: `profile-cli`, `profile-dev`, `profile-desktop`, `profile-darwin`, `profile-linux`.
- NixOS: `profile-desktop`, `profile-server`, `profile-vm`.
- Darwin: `profile-base`, `profile-desktop`, `profile-laptop`.

Important user modules:

- `homeManager.user-kaktus` and `homeManager.kaktus` set Home Manager user defaults.
- `nixos.user-kaktus` creates the Linux user account.
- `nixos.user-kaktus-desktop` includes Home Manager desktop/dev profiles.
- `nixos.user-kaktus-server` includes only CLI/Linux Home Manager profiles.
- `darwin.user-kaktus` creates the Darwin user account.

## Implementation Notes

- `modules/features/core.nix` registers both `nixos.core` and `darwin.core` for shared system-level Nix settings, unfree packages, fonts, and SSH authorized keys.
- `modules/features/btop.nix` guards `nvtopPackages.apple` to Darwin so Linux server targets can evaluate.
- `modules/features/stylix.nix` points to `assets/wallpapers/love_lain.jpg`.
- `modules/flake/devshells.nix` sets `devenv.root` with `lib.mkOverride 900` as a fallback; `.envrc` passes `devenv-root` so devenv's flake-parts module can override it with the real working-tree path.
- The old `zsh_alias` Home Manager module remains as an alias to `zsh-aliases` for compatibility.

## Verification State

The following passed with `path:/Users/kaktus/nix-config` and `XDG_CACHE_HOME=/private/tmp/codex-nix-cache`:

- `nix flake show --show-trace path:/Users/kaktus/nix-config`
- `nix eval --show-trace path:/Users/kaktus/nix-config#nixosConfigurations.fishhook.config.system.stateVersion`
- `nix eval --show-trace path:/Users/kaktus/nix-config#nixosConfigurations.cholla.config.system.stateVersion`
- `nix eval --show-trace path:/Users/kaktus/nix-config#darwinConfigurations.saguaro.config.system.stateVersion`
- `nix build --dry-run --show-trace path:/Users/kaktus/nix-config#darwinConfigurations.saguaro.system`
- `nix build --dry-run --show-trace path:/Users/kaktus/nix-config#nixosConfigurations.fishhook.config.system.build.toplevel`

Known remaining limitations:

- `nix flake check` could not run in this sandbox because it needs access to `/nix/var/nix/daemon-socket/socket`.
- `cholla` build derivation evaluation still fails because host-specific hardware details are incomplete: missing root `fileSystems` and incorrect/missing Asahi peripheral firmware location.
- Plain `git+file` flake evaluation ignores newly moved untracked files until the refactor paths are added to Git, so use `path:/Users/kaktus/nix-config` during local uncommitted verification.
