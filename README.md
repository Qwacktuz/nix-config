# Nix configuration flake

- Featuring a dendritic pattern approach
- [Luna migration plan and review checklist](docs/luna-migration.md)
- [Repository memory](docs/MEMORY.md)
- [Local English/Norwegian writing checks](docs/writing.md)
- [SOPS setup, machine enrollment, recovery, and rotation](docs/secrets.md)

## Package ownership

Nix owns CLI tools, configuration, and project toolchains. Homebrew casks own
ordinary macOS GUI apps; Home Manager retains supported settings. JetBrains,
optional Spicetify/Tenacity, and optional qBittorrent/Xournal++ are documented Nix exceptions.
Luna gets daily apps; Saguaro explicitly selects optional app collections.

Project shells: `nix develop .#go`, `.#rust`, `.#jvm`, `.#python`, `.#web`,
`.#infra`, or `.#c`. See the migration plan before switching a new Mac.

## Caveats

- Commands such as `nix flake show` won't work properly since dendritic nix
  design implements flakes using: `flake.modules.<module class>.<aspect name>`,
  where the aspect name is a feature/module name and the module class can be
  `homeManager`, `darwin`, `nixos`
  - Normal flake-parts modules follow the pattern `flake.<host>` where host can
    be `darwinConfiugrations`, `homeManagerModules`, `darwinModules` or
    `nixosModules`
- GNU coreutils doesn't exist on macOS and it's needed for flags like `--no-preserve` and `--reflink` when using `nix run .#write-flake` with github:vic/flake-file. The fix is to temporarily add it to PATH:

```bash
nix shell nixpkgs#coreutils --command nix run .#write-flake
```

## TODO

See [the TODO/FIXME audit](docs/todo-audit.md) for fixes, proposals, and validation.

- set up kanata keybinds <https://github.com/jtroo/kanata>
- set up <https://github.com/oddlama/nix-topology>
- Further modularize packages into packages built with perSystem (flake parts) so I can build for each system using DRY (limit identical configuration in separate independent darwinModules or nixosModules)
  - May use <https://birdeehub.github.io/nix-wrapper-modules/md/getting-started.html>
  - Look into how to build my own derivations (everything cross platform should exist in a perSystem package derivation)
- Consider migrating from HCL to terranix (compiles to \*.tf.json)
  - <https://terranix.org/getting-started.html>
- Streamline devshell creation
- Consider moving back to pure direnv (not sure if I need devenv capabilities really) - make sure to disable warnings and logging (env var?)

## Various resources

**Docs/cheatsheets:**

- <https://jdheyburn.co.uk/blog/nix-cheat-sheet>

- [Automatic lock flattening](https://github.com/fzakaria/nix-auto-follow)

**Flake parts and dendritic design:**

- <https://flake.parts>
- <https://github.com/Doc-Steve/dendritic-design-with-flake-parts>
- <https://dendrix.oeiuwq.com>
- <https://github.com/vic/flake-file>

## How to install MacOS

Download the determinate nix pkg from

- <https://docs.determinate.systems/guides/migrating-from-upstream-nix/>

Use the machine's SSH Ed25519 host key for system SOPS decryption:

```sh
# Generate missing host keys without replacing existing keys.
sudo /usr/bin/ssh-keygen -A

# Generate from host ssh key (recommended)
nix run nixpkgs#ssh-to-age -- -i /etc/ssh/ssh_host_ed25519_key.pub

```

Add the resulting public age recipient to the `pubkeys.yaml` rule in
`.sops.yaml`. On a machine with existing decryption access, run:

```sh
SOPS_AGE_KEY_FILE="$HOME/.config/sops/age/keys.txt" \
  sops updatekeys secrets/pubkeys.yaml
```

Back up the private SSH host key securely. For user secrets, restore your
personal age identity to `~/.config/sops/age/keys.txt` with mode `0600` and its
parent directory mode `0700`. It must match the personal recipient enrolled for
`home.yaml`. See [the SOPS guide](docs/secrets.md) before activating a new host.
