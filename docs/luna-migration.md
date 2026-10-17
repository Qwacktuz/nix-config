# Luna migration plan

Target: `darwinConfigurations.luna`, an Apple Silicon MacBook Pro
(`aarch64-darwin`). Review branch: `codex/luna-cleanup`, based on the existing
TODO-fix commits. One jj commit per numbered step. Leave main unchanged until
user review and approval; do not activate this machine during cleanup.

## Ownership

- Nix: CLI applications, configuration, services, and project toolchains.
- Homebrew casks: ordinary macOS GUI applications. Home Manager keeps settings
  where its module supports configuration without installing the application.
- Explicit Nix GUI exceptions: JetBrains IDE/plugin wrappers and Spicetify.
- Linux GUI packages: Nix, only in desktop roles.
- Each application has one installation owner; profiles compose features.
- Compilers/runtimes/SDKs: named project shells, except editor dependencies.
- macOS Tailscale: standalone app, without an additional nix-darwin daemon.
- macOS containers: OrbStack; heavier VM tools are opt-in.

## Commit sequence

1. Record the plan and refresh repository MEMORY.md.
2. Disable Brew automatic updates/upgrades; use cleanup `none` during migration.
3. Split home-packages into CLI, development, desktop, security, and editor
   features. Remove redundant imports and duplicate Zed ownership.
4. Add Go, Rust, JVM, Python, web, infrastructure, and C/C++ project shells;
   remove their toolchains from global development packages.
5. Move ordinary Darwin GUI apps to validated pinned casks; retain supported
   Home Manager configuration and Linux Nix ownership.
6. Separate daily apps from optional communications, games, peripherals,
   creative apps, and VM tools. Luna selects daily apps; Saguaro explicitly
   selects extras. Consolidate Tailscale and the default container runtime.
7. Verify hosts, shells, and ownership invariants; update docs/memory with
   results and present the complete series for review before merging main.

## Migration checks

- Determinate Nix must be installed when `nix.enable = false`.
- The macOS account is `kaktus`; repo location is `~/nix-config` because the
  Neovim/Karabiner dotfiles use out-of-store links there.
- Build with `nh darwin build ~/nix-config --hostname luna` before switching.
- Do not copy old Nix application symlinks with Migration Assistant.
- Sign-ins, licenses, app data, secrets, and macOS permissions need separate
  migration. Test keyboard/window management, VPN, terminal, and IDE plugins.
- Cask declarations do not provide Nix store rollback of application binaries.
- After approval, advance local main to the reviewed descendant using jj.
  No remote push is authorized by this task.

## Progress

Plan recorded; implementation and verification pending.
