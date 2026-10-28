# New Mac migration checklist

Luna and Saguaro select `darwin.profile-full`; Sol selects `profile-core` and
`profile-dev`. All are `aarch64-darwin` with the `kaktus` account. The earlier
Luna-only migration and its temporary review workflow are complete historical
work; this checklist describes the current configuration.

## Before activation

1. Install Determinate Nix; the Darwin hosts set `nix.enable = false`.
2. Clone the repository to `~/nix-config` for the out-of-store dotfile links.
   Track new configuration files before evaluating the Git-backed flake.
3. Provision the machine's SSH host identity and enroll its public age recipient
   for `secrets/pubkeys.yaml`. Restore or enroll a user age identity for the
   user secrets. Follow [secrets.md](secrets.md), including decryption checks.
4. Back up existing app data and configuration. Migrate sign-ins and licenses
   separately; avoid copying stale Nix application symlinks with Migration
   Assistant. Homebrew casks do not provide Nix-store rollback of app binaries.
5. Check the selected profile in `modules/hosts/`, then validate and build:

   ```sh
   python3 scripts/check-brew-casks.py luna
   nix build .#checks.aarch64-darwin.profile-policy .#checks.aarch64-darwin.secrets
   nh darwin build ~/nix-config --hostname luna
   ```

Use the target hostname. The cask checker requires an initialized Homebrew
installation. With immutable taps, update compatible Homebrew implementation
and tap pins together rather than trying to repair the managed tree manually.

## Activate and verify

```sh
nh darwin switch ~/nix-config --hostname luna
```

Activation removes unselected managed Homebrew packages. Keep console access
and an existing SSH session while changing authorization. Verify a second SSH
login and runtime secrets before closing that session.

Test keyboard/window management, VPN, terminal, wallpaper, backup tools, and
IDE plugins on the actual Mac. Grant macOS permissions when requested.
WireGuard's App Store installation requires an Apple account. Log in to
`pass-cli` and import software SSH keys into Proton Pass before relying on the
configured agent. Run the JetBrains and Spicetify helpers described in
[macOS GUI ownership](macos-gui-apps.md) after installing/opening the apps.

## Project toolchains

Use `nix develop ~/nix-config#<name>` or `use flake ~/nix-config#<name>`
in a project's `.envrc`. Projects needing independent pins should own a flake
and lock rather than relying on a mutable checkout.

| Shell | Tools |
| --- | --- |
| `go` | Go, gopls, golangci-lint and its language server |
| `rust` | Cargo, rustc, rustfmt, Clippy, rust-analyzer |
| `jvm` | Java, Kotlin, Gradle, Android CLI tools |
| `python` | Stable Python, uv, pixi |
| `web` | Node.js, TypeScript, Bun, Deno, pnpm |
| `infra` | act, Infisical, tenv, Ansible, Flux, AWS CLI, Packer, Kubernetes tools |
| `c` | Native compiler environment, clang-tools, CMake, Make, Zig, platform debugger |

The dev profile also provides Node.js, Lua, a compiler, and Tree-sitter for
editor plugins. Creative provides TeX and writing tools. See
[profiles.md](profiles.md) for package placement.

## Validation scope

A build verifies Nix derivations, not Homebrew downloads, secret enrollment, or
GUI startup. Historical migration checks are not a current validation result.
After changing inputs or profiles, rerun the checks in the [README](../README.md).
