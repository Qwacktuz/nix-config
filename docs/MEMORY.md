# Repository maintenance notes

Reviewed 2026-10-29 against the tracked configuration. These are current
maintenance notes; historical implementation details remain in Git history.

## Structure and invariants

- `flake.nix` is generated. Declare inputs in the modules, then run
  `nix run .#write-flake` (with GNU coreutils on macOS).
- `modules/` is imported as flake-parts modules using import-tree. Keep plain
  data/check expressions outside it. `_cholla-hwconfig.nix` is a retained
  generated reference; `modules/hardware/cholla.nix` owns the active definition.
- Luna/Saguaro select full; Sol selects core and dev. Cholla selects full Home
  Manager; Fishhook selects CLI only. See [profiles.md](profiles.md).
- Preserve state versions and host-specific hardware settings.
- Preserve archived modules, alternate assets, and Karabiner backups unless
  their removal is explicitly intended. Exported features may have external
  consumers even when no local host selects them.
- Neovim and Karabiner use out-of-store links into `~/nix-config`.

## Ownership and integrations

- Homebrew owns ordinary macOS GUI apps. AeroSpace uses nix-darwin; Tenacity,
  qBittorrent, Xournal++, and mpv remain Nix GUI exceptions. Font Awesome uses
  Nix `fonts.packages`. See [macos-gui-apps.md](macos-gui-apps.md).
- Homebrew taps are immutable. Activation has `autoUpdate = false`,
  `upgrade = false`, and `cleanup = "uninstall"`.
- The pinned nixpkgs supplies the nix-output-monitor unknown-event fix;
  the duplicate local patch/overlay was removed.
- Local English grammar and English/Bokmål spelling are configured in
  `dotfiles/nvim/lua/plugins/writing.lua`; the server is provided by creative.
  See [writing.md](writing.md) for commands and the integration check.
- Load devenv's direnv integration lazily inside `use_devenv`: its helper names
  overlap nix-direnv's. Do not add a competing Zsh auto-activation hook.
- System SOPS uses each machine's SSH host identity. User SOPS uses a personal
  age identity at `~/.config/sops/age/keys.txt`. Never decrypt during evaluation.
  See [secrets.md](secrets.md) for enrollment and recovery.
- Mac SSH software keys are served by Proton Pass; public selectors and FIDO
  handles are deployed by SOPS. Do not remove the activation cleanup for old
  SOPS private-key links without confirming all machines have migrated.

## Validation limits

Run the checks in [README](../README.md#development-and-validation).
The profile policy must match selected profiles, including Sol's dev tools.
The cask checker loads Ruby definitions and catches parser incompatibilities as
well as platform-specific disabled casks; Nix builds alone cannot validate these.

The October 29 cleanup can be syntax-checked locally, but this assistant session
cannot access the Nix daemon or write Git metadata. Full evaluation, builds,
activation, and publishing must be verified separately if those restrictions
remain in place. Earlier migration check results apply to their old revisions,
not automatically to the current lock or checkout.

Cholla's full system needs the target's Asahi firmware location. Physical
YubiKey operations, MPD playback, GUI permissions, and app/plugin compatibility
require target-host testing. Remaining ideas are in [todo-audit.md](todo-audit.md).
