# macOS GUI app ownership

Luna and Saguaro prefer native nix-darwin modules for GUI apps when they provide
reliable installation, configuration, and service integration. AeroSpace uses
that route. Other GUI apps use Homebrew, with four documented Nix
exceptions. Home Manager may configure an app without owning its installation.
Nix owns Linux GUI packages. Nix also owns CLI/TUI tools, fonts,
configuration, and project environments.

## Audit and migration

| App | macOS installation | Configuration |
| --- | --- | --- |
| IntelliJ IDEA | `intellij-idea` cask | Existing plugin IDs retained in Nix-generated installer command |
| PyCharm | `pycharm` cask | Existing plugin IDs retained in Nix-generated installer command |
| WebStorm | `webstorm` cask | Existing plugin IDs retained in Nix-generated installer command |
| Spotify | `spotify` cask | Spicetify CLI, Catppuccin Mocha, adblockify and shuffle assets retained through Nix |
| AeroSpace | nix-darwin `services.aerospace` | Native module owns the package, TOML settings, and launchd startup |
| Karabiner-Elements | `karabiner-elements` cask | Existing `dotfiles/karabiner` config linked by Home Manager; native module has unresolved v15+ integration issues |
| mpv | Nix exception | Its cask is disabled; the Homebrew formula dependency graph fails with the pinned taps |
| Tenacity | Nix exception | No cask in the pinned Homebrew sources |
| qBittorrent | Nix exception | macOS cask disabled for failing Gatekeeper checks |
| Xournal++ | Nix exception | macOS cask disabled for failing Gatekeeper checks |

Tenacity, qBittorrent, and Xournal++ were explicitly approved as exceptions on
2026-10-19. mpv was restored to Nix after Homebrew activation failed: a local
`brew install --dry-run mpv` reproduces a `dav1d` formula evaluation error
(`undefined method 'new' for an instance of Symbol`). Removing mpv from the
Brewfile avoids that dependency graph without updating unrelated inputs.
Disabled casks are not added to the Brewfile. No application is silently replaced by a
different product.

Ghostty, Brave Origin, Zed, VSCodium, KeePassXC, Obsidian, LocalSend,
Yubico Authenticator, Tailscale, OrbStack, UTM, Prism Launcher, and the other
apps in the [package profiles](profiles.md) use casks. WireGuard remains an App Store
installation managed by Homebrew Bundle. The inactive examples under
`archive/unused-modules` do not contribute packages to any host.

`ani-cli` remains a Nix CLI tool, with its bundled Nix mpv dependency disabled
on Darwin; it resolves the globally installed Nix mpv through PATH. The exported Prism Launcher Home Manager feature is
guarded to Linux and is not selected by the current profiles. Browser engines and graphics libraries required internally
by CLI tools are dependencies, not separately installed desktop applications.

## Native module review

The pinned nix-darwin module inventory was compared with the configured app
list. AeroSpace is the supported match and retains its original native module.
Other native GUI integrations (such as Emacs, Arq, and 1Password) are not among
the selected apps; enabling unrelated apps is outside this migration.

Karabiner remains a cask because the earlier native-module review found
incompatible launch-agent paths for the v15+ app layout. Keep the cask until a
replacement is verified against the selected nix-darwin version and on the
actual host. Historical references: [issue #1041](https://github.com/nix-darwin/nix-darwin/issues/1041)
and [v15+ support PR](https://github.com/nix-darwin/nix-darwin/pull/1679).
Their current status is not a substitute for validating this configuration.

The native Tailscale module installs `tailscaled`, not the standalone GUI app.
The GUI cask remains the sole macOS backend. Likewise, `services.spotifyd`
is a separate daemon rather than the Spotify desktop app.

## After switching

Install the existing JetBrains plugin selections with the IDEs closed:

```sh
jetbrains-install-idea-plugins
jetbrains-install-pycharm-plugins
jetbrains-install-webstorm-plugins
```

These use JetBrains' `installPlugins` command and fetch plugins compatible with
the installed cask IDE. Linux retains the existing Nix plugin wrappers. The
macOS plugins are now installed in the user's JetBrains directories and are
not version-pinned by Nix. Existing IDE user settings are not deleted; a newer
IDE may prompt to import them. Plugin compatibility must be checked in the IDE.

Open Spotify once and sign in, then quit it and run:

```sh
spicetify-apply
```

The helper configures the cask's Spotify path and applies the declared theme
and extensions. Spicetify's writable configuration and backup state remain in
the user's directory. Reapply after Spotify upgrades; an upstream Spotify
change may require updating the Nix-managed Spicetify CLI first. The helper
is explicit and is not run during system activation.

AeroSpace uses `services.aerospace.enable = true` and its existing settings.
The native nix-darwin module installs the application and starts its Nix store
binary with generated TOML. Self-managed login startup remains off. The
intermediate cask, custom launchd definition, and extra tap have been removed.

Homebrew's activation update/upgrade flags and application update preferences
are unchanged by this migration. Update immutable taps through their flake
inputs when updating Homebrew packages.

## Validation

```sh
python3 scripts/check-brew-casks.py luna
python3 scripts/check-brew-casks.py saguaro
nix eval .#checks.aarch64-darwin.profile-policy.drvPath
nix flake check --no-build
```

The cask checker evaluates pinned cask definitions with Homebrew's Ruby DSL
on the current Mac, including third-party taps, without installing taps or
apps. The policy check covers every declared Darwin host's Home Manager and
system packages, required casks, and AeroSpace's executable location.

These commands must be rerun after changing the lock or package selections.
Earlier migration results refer to their historical revisions. Full system
activation and GUI/plugin behavior require checks on the target machine.

Font Awesome is now installed by Nix (`fonts.packages = [ pkgs.font-awesome ];`)
rather than Homebrew. The October 29 activation failure was caused by the
pinned cask's `zap :not_required` stanza being incompatible with the Nix-managed
Homebrew 7.0.4 parser. Nixpkgs and Homebrew pins can advance independently;
validate the implementation against the pinned taps before switching.

`check-flake-file` checks that generated `flake.nix` matches the declarations.
If it fails, inspect the generator's diff rather than assuming an old failure
still applies. GNU coreutils may be required on macOS (see the README).

Sources: [AeroSpace installation](https://nikitabobko.github.io/AeroSpace/guide#homebrew-installation-preferred),
[JetBrains plugin installation](https://www.jetbrains.com/help/idea/install-plugins-from-the-command-line.html),
[Spicetify configuration](https://spicetify.app/docs/customization/config-file).
