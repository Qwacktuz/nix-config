# Repository Memory

Updated 2026-10-18. Current task: prepare the Apple Silicon Luna migration.
Plan: [docs/luna-migration.md](docs/luna-migration.md).

## Workflow

- Use jj; one commit per logical change on `codex/luna-cleanup`.
- Starting commits: `98d38bb7` (Darwin profiles/Luna) and `c2806e65`
  (portable configuration fixes and TODO audit).
- main remains `ef1d2195`. Merge only after user review and approval.
- Do not activate the current machine during cleanup.

## Architecture

- flake.nix uses flake-parts and `inputs.import-tree ./modules`.
- Nix files in modules register `flake.modules.<class>.<feature>`;
  data/templates belong outside the recursive module import tree.
- modules/flake: inputs, outputs, aliases, formatter, devshells.
- modules/features: Home Manager, Darwin, and NixOS features.
- modules/profiles: feature bundles; modules/users: kaktus account/composition.
- modules/hosts/targets.nix: Saguaro/Luna (aarch64-darwin), Cholla
  (aarch64-linux Asahi), Fishhook (x86_64-linux Proxmox LXC).
- archive/unused-modules is inactive; dotfiles are outside the module tree.

## Cleanup policy and pending work

- Homebrew casks own ordinary macOS GUI apps; Nix owns CLI/configuration.
  JetBrains/plugin wrappers and Spicetify remain explicit Nix exceptions.
- Replace mixed home-packages with focused features and project toolchains.
- Remove duplicate Zed ownership and redundant imports.
- Standalone Tailscale app on macOS; keep the Linux NixOS service.
- OrbStack for default containers; optional VM tools.
- Luna gets daily apps; Saguaro explicitly selects optional collections.
- Disable Brew automatic update/upgrade and zap cleanup for migration.

## Verified starting state

- Saguaro, Luna, and Fishhook derivations evaluated after c2806e65.
- Cholla fails the Asahi peripheral-firmware location assertion on this Mac,
  reproduced at 98d38bb7. Root filesystems are configured; the old missing-root
  note was stale.
- Darwin MPD starts/responds in isolation; playback/launchd and Linux runtime
  still need target-host checks. See docs/todo-audit.md for remaining proposals.
- Snapshot new paths with jj before ordinary Git-flake evaluation.
- Darwin nix.enable=false assumes a separately installed Nix daemon.
- Preserve system and Home Manager state versions during refactoring.

Refresh final module names, commits, verification, and remaining requirements
at handoff.
