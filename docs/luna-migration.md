# Luna migration plan

Target: `darwinConfigurations.luna`, an Apple Silicon MacBook Pro
(`aarch64-darwin`). Review branch: `codex/luna-cleanup`, based on the existing
TODO-fix commits. One jj commit per numbered step. Leave main unchanged until
user review and approval; do not activate this machine during cleanup.

## Ownership

- Nix: CLI applications, configuration, services, and project toolchains.
- Homebrew casks: ordinary macOS GUI applications. Home Manager keeps settings
  where its module supports configuration without installing the application.
- Explicit Nix GUI exceptions: JetBrains IDE/plugin wrappers, optional
  Spicetify/Spotify, and optional Tenacity (no matching pinned cask).
  AeroSpace remains owned by its nix-darwin service.
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

## Project toolchains

Use `nix develop ~/nix-config#<name>` or `use flake ~/nix-config#<name>`
in a project's `.envrc`. Projects needing independent version pins should own
their own flake/lock instead of depending on a mutable checkout.

| Shell | Tools moved out of global development packages |
| --- | --- |
| `go` | Go, gopls, golangci-lint/language server |
| `rust` | Cargo, rustc, rustfmt, Clippy, rust-analyzer |
| `jvm` | Java, Kotlin, Gradle, Android CLI tools |
| `python` | Stable Python, uv, pixi; replaces global prerelease Python 3.15 |
| `web` | Node.js, TypeScript, Bun, Deno, pnpm |
| `infra` | act, Infisical, tenv, Ansible, Flux, AWS CLI, Packer, Kubernetes CLI |
| `c` | Native C/C++ compiler, clang-tools, CMake, Make, Zig, platform debugger |

Node.js, Lua, a native C compiler, Tree-sitter, and TeX tools remain in the
editor-runtime feature for existing Neovim plugins. These are editor support
dependencies, not the default project language versions. No repository lock
inputs or state versions were changed.

## Progress

Implementation complete; review and merge pending. Main has not moved.

| Commit | Change |
| --- | --- |
| `7d3125f4` | Plan and repository memory |
| `769462d0` | Predictable Brew activation |
| `8650b060` | Focused package features and profile boundaries |
| `ae25cd2b` | Seven named project toolchains |
| `cc58c7da` | Native macOS GUI ownership |
| `fcedbcae` | Daily Luna profile and optional Saguaro collections |
| `ce6dfb51` | Local palette; no theme build during evaluation |
| `c935ec7a` | Pinned native Spotify; remove obsolete DMG overlay |
| `4886854c` | Keep GPU monitors on desktops |
| `a8460831` | Correct nh paths on Linux and Darwin |
| `02b8399b` | Profile ownership regression checks |
| `19433373` | Preserve authenticator and optional Parsec |
| `38010f59` | Export only the three supported host platforms |
| `d207aacc` | Respect ARM Linux optional-app availability |

The final documentation commit refreshes this document, the TODO audit, README,
and MEMORY.md. The review also includes the preceding `98d38bb7`/`c2806e65`
baseline and TODO-fix commits, since main is still `ef1d2195`.

## Final selections

Luna's 16 casks: Ghostty, Brave Origin, Zed, VSCodium, Obsidian, LocalSend,
KeePassXC, Stats, IINA, Karabiner Elements, LuLu, Font Awesome, Codex,
Tailscale standalone, OrbStack, and Yubico Authenticator.

Saguaro explicitly imports `darwin.profile-extras` and Home Manager
`profile-extras` plus `profile-darwin-extras`. Cholla imports the common
Home Manager extras. Fishhook remains CLI-only. Enabling an optional Darwin
app group requires importing its named `darwin.apps-*` feature into the host;
the full optional bundle is `darwin.profile-extras`.

The common Home Manager extras include personal CLI/security tools, Linux
optional desktop apps, Tenacity/mpv, and MPD. Darwin extras add Spicetify and
Lima/QEMU; the Darwin VM feature supplies UTM. Prism Launcher on Darwin is now
an optional cask: the launcher manages Java installations instead of using the
previous Nix wrapper's four bundled JDKs.

Home Manager uses `programs.brave-origin` with no package on Darwin so extension
files go to Brave Origin's actual profile directory. The old Nix wrapper's
payment-autofill launch flag applies only to Linux now; use the browser's
payment settings on macOS. Ghostty, Zed, and VSCodium also use config-only
modules on Darwin. JetBrains plugins and VSCodium extensions remain declarative.

`xcodes` and `macpm` remain Nix CLI tools. All old Saguaro casks are retained
between daily/optional groups; `picocom` has one Nix owner, and the `mas` CLI
and WireGuard App Store declaration are optional. App self-updaters are
independent of the disabled Brew activation update/upgrade flags.

## Verification

- `nix flake check --offline --no-build --option allow-import-from-derivation false`
  passed on aarch64-darwin.
- `checks.aarch64-darwin.profile-policy` evaluated and built successfully.
  It checks pinned cask existence, unique ownership, role boundaries, runtime
  selection, rebuild aliases, and nh paths.
- All 21 named project-shell derivations evaluated for aarch64-darwin,
  aarch64-linux, and x86_64-linux.
- Luna and Saguaro system derivations evaluated with evaluation-time builds
  disabled. Luna's full system build **dry-run** passed; binaries were not
  built/installed, and casks were not downloaded or activated.
- Fishhook's system derivation evaluated. Cholla's Home Manager generation
  evaluates; its full NixOS system still needs the host's Asahi firmware path.
- Cholla skips unsupported optional Proton Mail Desktop and Proton Pass and
  reports them in Home Manager warnings.
- The palette is the exact Catppuccin Mocha color data from the original
  pinned schemes revision, with source attribution in the local data file.
- Existing upstream Rofi option-renaming and options.json source-context
  warnings remain.

## Review gate

Review with `jj diff --from main --to codex/luna-cleanup` and
`jj log -r 'main..codex/luna-cleanup'`. Main stays unchanged until explicit
approval. The merge after approval is a local fast-forward of main to the
reviewed descendant, preserving each jj commit. No remote push is included.
