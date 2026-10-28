# Nix configuration flake

Personal NixOS and nix-darwin configuration using flake-parts and the dendritic
module pattern. `flake.nix` is generated from `modules/`; edit input declarations
there rather than editing the generated file directly.

| Host | Platform | Selection |
| --- | --- | --- |
| Luna | `aarch64-darwin` | Full |
| Saguaro | `aarch64-darwin` | Full |
| Sol | `aarch64-darwin` | Core and dev |
| Cholla | `aarch64-linux` (Asahi) | NixOS desktop and full Home Manager |
| Fishhook | `x86_64-linux` (Proxmox LXC) | NixOS server and CLI Home Manager |

## Setup and switching

Clone to `~/nix-config`: Home Manager's Neovim and Karabiner configurations use
out-of-store links to this checkout. The configured account is `kaktus`.
The Macs use Determinate Nix with `nix.enable = false`.

Provision user and system identities using [the secrets guide](docs/secrets.md)
before activation. For a new Mac, follow [the migration checklist](docs/luna-migration.md).

```sh
nh darwin build ~/nix-config --hostname luna
nh darwin switch ~/nix-config --hostname luna
# NixOS, on the target host:
nh os switch ~/nix-config --hostname fishhook
```

Use the desired hostname. A successful Nix build does not guarantee successful
Homebrew installation or runtime secret decryption during activation.

## Package ownership and profiles

Nix owns CLI tools, fonts, configuration, and project toolchains. AeroSpace uses
its native nix-darwin service. Other macOS GUI apps use Homebrew casks, with
Tenacity, qBittorrent, Xournal++, and mpv retained as Nix exceptions.
Home Manager keeps supported app settings without duplicating cask installs.
Font Awesome is installed through `fonts.packages` to avoid an incompatible
Homebrew cask stanza.

- [Profile selection and package placement](docs/profiles.md)
- [macOS app ownership and post-switch helpers](docs/macos-gui-apps.md)
- [Local English/Bokmål writing checks](docs/writing.md)
- [SOPS enrollment, recovery, and rotation](docs/secrets.md)
- [Repository maintenance notes](docs/MEMORY.md)
- [Remaining proposals](docs/todo-audit.md)

Homebrew taps are immutable and pinned by `flake.lock`. Activation does not
update or upgrade packages, but `cleanup = "uninstall"` removes unselected
managed packages. Individual apps may have their own update mechanisms.

## Development and validation

`direnv allow` loads the default devenv shell; alternatively use `nix develop`.
It provides `napply`, `nfmt`, `ncheck`, formatting hooks, and a staged Gitleaks
hook. Project shells are `go`, `rust`, `jvm`, `python`, `web`, `infra`, and `c`:

```sh
nix develop .#rust
nix fmt
nix flake check --no-build
nix build .#checks.aarch64-darwin.profile-policy .#checks.aarch64-darwin.secrets
python3 scripts/check-brew-casks.py luna
```

The cask checker requires macOS and Homebrew; it loads pinned definitions
without installing apps. `--no-build` evaluates checks but does not execute
check derivations. Cholla's full system requires its Asahi firmware location;
cross-platform outputs may need a builder for their architecture.

Track new files before evaluating the Git-backed flake. In a colocated Jujutsu
checkout, `jj status` snapshots them into the working-copy change. Named project
shells share this repository's pins; projects needing independent versions
should keep their own flakes and locks.

Regenerate `flake.nix` after changing module input declarations:

```sh
nix shell nixpkgs#coreutils --command nix run .#write-flake
```

GNU coreutils supplies flags required by the generator on macOS. Regeneration
is separate from updating inputs with `nix flake update`. After an input update,
check Homebrew implementation/tap compatibility as well as Nix evaluation.
`update_saguaro.sh` formats, checks, regenerates the flake, switches Saguaro,
and optionally runs cleanup; it does not explicitly update input pins.

## Wallpaper

All Darwin hosts use the image selected by `stylix.image` in
`modules/features/stylix.nix`, currently `assets/wallpapers/spacegirl.png`.
Home Manager's `desktoppr` integration applies it during activation and at
graphical login, scaled to fill each screen. Add and track a new image, update
that path, and switch. Manual wallpaper changes are overwritten on login.

## Architecture and resources

`inputs.import-tree ./modules` loads the module declarations.
`flake.modules.<class>.<feature>` registers modules for `darwin`, `nixos`, or
`homeManager`; host outputs are constructed in `modules/hosts/targets.nix`.
Ordinary Nix data and check expressions belong outside this import tree.
`archive/unused-modules` is inactive and retained for reference.

- [flake-parts](https://flake.parts)
- [Dendritic design](https://github.com/Doc-Steve/dendritic-design-with-flake-parts)
- [Dendrix](https://dendrix.oeiuwq.com)
- [flake-file](https://github.com/vic/flake-file)
- [Automatic lock following](https://github.com/fzakaria/nix-auto-follow)
- [Nix cheat sheet](https://jdheyburn.co.uk/blog/nix-cheat-sheet)
