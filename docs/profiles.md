# Package profiles

| Category | Contents | Source |
| --- | --- | --- |
| `core` | Daily apps, shell/CLI essentials, Git/SSH, secrets, desktop settings | [core.nix](../modules/profiles/core.nix) |
| `dev` | IDEs, development tools, editor runtimes, containers and VMs | [dev.nix](../modules/profiles/dev.nix) |
| `gaming` | Steam, launchers, game streaming and terminal amusements | [gaming.nix](../modules/profiles/gaming.nix) |
| `creative` | Audio/video/image tools, writing/typesetting and drawing peripherals | [creative.nix](../modules/profiles/creative.nix) |
| `security` | Network analysis, forensics and vulnerability scanners | [security.nix](../modules/profiles/security.nix) |
| `full` | Imports all five categories; owns no package lists | [full.nix](../modules/profiles/full.nix) |

Sol imports `darwin.profile-core` and `darwin.profile-dev`. Saguaro and Luna import
`darwin.profile-full`, giving them the same casks, formulas, App Store apps,
Home Manager packages and system packages.

Core includes Brave Origin, Signal, Proton Pass, Ghostty, Spotify, the existing
desktop utilities, messaging/mail apps, backup and study apps. Git, SSH/SOPS,
YubiKey support, AeroSpace and theming remain core infrastructure. Specialist
security tools belong to `security`. OrbStack, UTM, Lima and QEMU belong to `dev`.

## Selecting profiles

Each category defines its Darwin and Home Manager parts in the same file.
Importing a Darwin profile wires its Home Manager part automatically; hosts
do not repeat user-level imports. The user module only supplies identity and
Home Manager integration.

Categories do not import one another. A custom Mac selection can import
`profile-core` and `profile-dev` instead of `profile-full`. Machine settings
such as hostname remain in `modules/hosts/`. OS defaults remain in
`darwin-base.nix` and `modules/features/system-base.nix`.

## Adding or moving a package

- Put a plain macOS GUI app in its category's `homebrew.casks` list, a Homebrew
  formula in `homebrew.brews`, or a Nix utility in `home.packages`.
- Keep configured applications in `modules/features/`. Select their feature
  modules from the appropriate category. The feature owns the application's
  package and settings; do not repeat its package in the category's plain list.
- Move an app and its configuration imports together when changing category.
  Platform-specific dependencies stay alongside the app they support.
- Keep project language toolchains in the existing project development shells.

Font Awesome is a system font installed through Darwin `fonts.packages`,
alongside the base JetBrains Mono Nerd Font.

Homebrew remains the macOS GUI owner except for AeroSpace's native Darwin
service and the existing Nix exceptions. qBittorrent is in core; Tenacity,
mpv and Xournal++ are in creative. See [GUI ownership](macos-gui-apps.md).

## Linux and validation

Cholla explicitly selects `homeManager.profile-full`; Fishhook selects the
CLI foundation, `homeManager.profile-cli`, defined in `core.nix`. Linux package
availability filters and platform-specific lists preserve their pre-refactor
package inventories. The NixOS desktop/server profiles contain system setup,
not another desktop application selection.

`checks/profile-policy.nix` checks full-host parity, Sol's essential apps and
category exclusions (Sol excludes gaming, creative, and security), package
ownership and secrets. Validate without activation:

```sh
nix eval .#checks.aarch64-darwin.profile-policy.drvPath
nix flake check --no-build
```

New files must be tracked before using the Git-backed flake. In this colocated
Jujutsu repository, `jj status` snapshots new files into the working-copy change.
Profile edits do not change installed applications until a rebuild/switch.
The existing Homebrew cleanup policy removes unselected managed apps on switch.
