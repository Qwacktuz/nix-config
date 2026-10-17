# TODO/FIXME audit

Audited 2026-10-18, after baseline commit `98d38bb7`.

Scope: all TODO/FIXME comments in tracked source, the README backlog, and
commented-out/archived configuration. The `todo` package is an application,
not an unresolved annotation. Existing TODO comments remain where implementation
needs requirements or host-specific verification.

## Implemented fixes and resolved decisions

| Location | Resolution |
| --- | --- |
| `modules/profiles/darwin-base.nix`: networking extraction | Moved the existing settings unchanged into `modules/features/networking.nix`, under `flake.modules.darwin.networking`. The base profile imports it. |
| `modules/users/kaktus.nix`: Spicetify setting | Moved the Stylix target override into the Spicetify feature and made it a default, so hosts can override it. |
| `modules/features/zsh-aliases.nix`: aliases and vi keybindings | Declared Home Manager's `defaultKeymap = "viins"`; retained both Ctrl-R bindings. `open`, `nix-switch`, `nix-update`, and `nix-test` now select valid Darwin/Linux commands. On Darwin, `nix-test` builds without activation. No unspecified additional keybindings were invented. |
| `modules/features/git.nix`: alias placement | Keep Git aliases with the feature that installs Git, lazygit, and onefetch. Moving them into the generic shell feature would couple unrelated shell users to those tools. Replaced the speculative TODO with that rationale. |
| `modules/features/llm.nix`: conditional Ollama configuration | Home Manager already gates service generation on `services.ollama.enable`. Removed redundant package/host/port assignments and made the disabled setting overridable with `mkDefault`. No server was enabled. |
| `modules/features/btop.nix`: GPU monitor portability | Select `nvtopPackages.apple` on Darwin and `nvtopPackages.full` on Linux. Removed the duplicate Apple package from `darwin-packages.nix`. GPU detection still needs a physical host check. |
| `modules/features/music.nix`: broken MPD configuration | Select CoreAudio on Darwin and PulseAudio on Linux, including PipeWire's PulseAudio compatibility service. Create music/state/playlist/log directories during activation. Remove the obsolete decoder block and unrelated FIFO options. Store the visualizer FIFO in the user's MPD directory and give ncmpcpp the same path. Enable automatic database updates only on Linux; the installed Darwin build lacks inotify support, so database updates there remain manual. |
| `modules/features/fastfetch.nix`: dynamic logo | Explicitly use `logo.type = "auto"`, allowing Fastfetch to detect the OS and choose a built-in logo without depending on image protocols. |
| README: devshell ergonomics | Corrected `napply` to select `nh darwin switch` or `nh os switch` using the shell's platform. Corrected the Kanata repository link. |

## Active proposals

Each entry identifies the next concrete patch and its completion check. These
are proposals, not claims that the remaining work has been implemented.

### GUI packages on Darwin

Source: `modules/features/home-packages.nix`.

Move GUI applications to a `desktop-apps` feature with Linux Home Manager and
Darwin Homebrew implementations. Start with Obsidian, LocalSend, qBittorrent,
Xournal++, Remmina, Proton Mail, Proton Mail Bridge, and Proton Pass. Audit the
rest of the list too: mpv, Tenacity, Zed, Anki, and similar tools also provide
GUIs. Keep the Proton exporter as a CLI until its actual package contents are
checked. Remmina needs a deliberate macOS replacement if no matching cask is
available; do not remove it silently.

Before changing ownership, inspect every application identifier against the
**pinned** `homebrew-cask` input, compare bundle names and architecture support,
and account for existing app preferences. Evaluate both Darwin hosts and Cholla;
then test one switch for duplicate bundles, extension paths, and file associations.
Homebrew currently uses cleanup `zap`, so review the generated Brewfile before
removing or renaming any managed application.

### Global development tools

Source: `modules/features/home-packages.nix` and README package/devshell tasks.

Split language runtimes/build tools into opt-in features for Go, Rust, JVM,
Python, JS/TS, and infrastructure. Provide matching `devenv` project templates;
migrate projects to those shells before dropping tools from `profile-dev`.
Retain global editor/LSP dependencies until their executable paths are explicit.
First pilot: move Gradle and Kotlin into a JVM project shell, then verify the
IDE, language server, and command-line build from a fresh shell.

Use flake-parts `perSystem.packages` for actual custom derivations and wrappers.
Keep package selections and service configuration in their appropriate modules;
adding aliases for all of nixpkgs does not itself provide cross-platform builds.
Build each custom package on its supported systems rather than claiming support
from an attribute name alone. No custom derivation requiring this migration was
identified in this repository.

### Atuin history

Source: the commented `autin` entry in `home-packages.nix` (spelling: **Atuin**).

Create an optional Home Manager `atuin` feature with Zsh integration. Decide
which history widget owns Ctrl-R before enabling it; the current configuration
explicitly binds fzf in insert and command modes. Preserve fzf for file and
directory search. Keep remote synchronization opt-in until the server, account,
and encryption-key storage are chosen. Verify history recording, both vi modes,
and terminal restarts before migrating/importing existing history.

### YubiKey feature

Source: `home-packages.nix`, with an existing Darwin cask in `homebrew.nix`.

Create a `yubikey` feature owning the existing `yubico-piv-tool`,
`yubikey-manager`, and `opensc` packages, plus the Darwin
`yubico-authenticator` cask. Check the pinned Linux authenticator package and
add it only to desktop hosts that need it. Configure any required Linux
smart-card service at the NixOS layer. Validate hardware detection, the existing
SSH security-key login, and the chosen PIV/OTP workflows on each target OS.

### VSCodium MCP

Source: the commented `userMcp` entry in `modules/features/vscodium.nix`.

Choose concrete servers, their purpose, and their transport before adding a
profile MCP configuration. Use the pinned Home Manager option schema and the
installed VSCodium version to confirm support. Declare server executables
through Nix, and reference runtime environment variables for credentials.
Acceptance: the selected server starts from the editor and can perform its
intended task. An empty MCP object would only hide the TODO.

### Finder desktop grid

Source: commented-out `DesktopViewSettings` in `darwin-base.nix`.

The entire preferences block is disabled, so this is not an active evaluation
failure. First reproduce the desired desktop icon arrangement on the target
macOS version, export `com.apple.finder` before/after changing it in the UI,
and inspect whether the setting is stored in preferences or per-folder metadata.
Only then add the observed key under `system.defaults.CustomUserPreferences`.
Verify after relaunching Finder and logging in again. Do not activate the whole
old block merely to test this key.

### MPD playback on target hosts

The parser/startup fixes above do not establish that sound plays. On Cholla,
verify the audio server first: the tracked host modules do not explicitly
enable PipeWire/PulseAudio. If none is provided elsewhere, configure
`services.pipewire.enable`, `services.pipewire.pulse.enable`, and
`security.rtkit.enable` in the desktop profile, then verify a real track from
MPD and ncmpcpp. On Darwin, test CoreAudio after a fresh login and trigger a
manual database update after adding music. Keep this separate from the
successful configuration/startup check.

## README backlog

| Item | Proposed patch and acceptance check |
| --- | --- |
| Kanata | Define the intended key layout and choose how it coexists with the current Karabiner configuration. Add an optional OS-specific feature and deploy on one host first. Check startup, normal typing, modifier combinations, and recovery when the remapper is stopped. [Upstream](https://github.com/jtroo/kanata). |
| nix-topology | Add a dedicated flake module, import its NixOS integration, and describe external routers/switches and the Darwin machines explicitly. Build a topology SVG and compare it with the actual network; routing/interface information must come from the hosts, not guesses. [Documentation](https://oddlama.github.io/nix-topology/). |
| Per-system packages and derivations | Follow the staged package migration above. Keep OS service modules separate from shared derivations; verify supported outputs with targeted native builds. Evaluate wrapper modules only when a concrete wrapper is needed. |
| HCL to Terranix | No tracked Terraform/HCL project was found here. Identify the actual infrastructure repository first. Convert one small component there, compare generated JSON, then require a plan showing no infrastructure changes before adoption. [Terranix](https://terranix.org/). |
| Streamline devshells | Fixed platform selection for `napply`. Next, add reusable language shell templates without removing the current shell. Test `nix develop`, direnv entry/re-entry, `nfmt`, `ncheck`, and the pre-commit hook from a fresh checkout. |
| Pure direnv instead of devenv | Keep devenv for now: this repo uses its scripts and Git-hook integration. Measure cold/warm entry, then prototype a plain `mkShell` carrying equivalent scripts, packages, and hooks. Configure quieter direnv output independently rather than changing environment management to suppress logs. Adopt the prototype only if those behaviors remain available. |
| LanguageTool/Neovim/Norwegian | `ltex-ls-plus` is already installed, but `dotfiles/nvim/lua/plugins/ltex-ls.lua` is entirely commented out. Replace it with an active `ltex_plus` server configuration in `lsp.lua`, using the Nix executable instead of a duplicate Mason install. Start with local English checking. LTeX+ documents Norwegian Bokmål only through `api.languagetoolplus.com`; choose explicitly between that service and local Neovim Norwegian spell files. Test an English error and a Norwegian typo in Markdown and Typst before calling this complete. [Language support](https://ltex-plus.github.io/ltex-plus/supported-languages.html). |

## Inactive annotations

These files are outside `import-tree ./modules`, or contain disabled Lua code.
They were inspected but were not reactivated or deleted to clear annotations.

| Location | Disposition / fix if revived |
| --- | --- |
| `archive/unused-modules/darwin/default.nix`: SOPS | Inspect the archived SOPS module, secret paths, and activation ordering; test decryption with the intended host's key before importing it. Never copy keys into the Nix store. |
| `archive/unused-modules/home/vesktop.nix`: Stylix theme/accent | Confirm the pinned Stylix/Vesktop interface, then replace hardcoded theme colors with the selected palette. Verify the generated theme and the running app. |
| `archive/unused-modules/home/zen-browser.nix`: bookmarks | Specify the desired bookmark tree and reconcile existing profile data before enabling declarative bookmarks. |
| Same file: upstream browser issue | The old comment does not establish that the issue still affects a current browser. If the module is revived, recheck the upstream issue against the selected version, reproduce it, and remove the fallback browser only after testing the replacement. |
| Same file: cookie persistence | Inspect the generated browser policies and cookie/session preferences; test a restart with a disposable profile before managing the real profile. |
| `dotfiles/nvim/lua/plugins/ltex-ls.lua`: move into `lsp.lua` | Included in the active LanguageTool proposal above. The old file currently returns no plugin specification. |
| Same file: n-gram data | Defer until the basic language server works. Select a supported corpus, provision it outside the Git repo, configure its path, and compare diagnostics/performance on a fixed sample. It does not solve the Norwegian language-support limitation. |

## Validation

- Baseline commit: Saguaro, Luna, and Fishhook system derivations evaluated.
- Branch: final Saguaro, Luna, and Fishhook system derivations evaluated.
  Targeted assertions checked Darwin/Linux shell aliases, vi keymap, Ollama's
  disabled default, Spicetify's Stylix override, the Linux GPU package, and
  the Linux MPD output selection.
- Cholla's full system evaluation fails the Asahi peripheral-firmware location
  assertion on this Mac. The same failure was reproduced at `98d38bb7`.
  Its Home Manager MPD configuration and Linux aliases can be evaluated
  separately; those select PulseAudio and `nh os` respectively.
- The generated Darwin MPD configuration starts and answers `status` through
  an isolated temporary Unix socket. First-run missing database/state messages
  are expected. Audio playback, launchd startup, Linux runtime behavior, and
  physical GPU access still require a target-host check.
- Fastfetch parsed the generated configuration and rendered the detected macOS
  logo. Nix formatting checks and whitespace checks passed for the branch diff.
- Existing upstream warnings about the renamed Rofi font option and the
  `options.json` derivation's source context remain; neither originates in the
  TODO fixes. Full system builds were not run.
- No system configuration was activated, no infrastructure was changed, and
  no external service was configured.

Implementation references:
[Home Manager MPD](https://github.com/nix-community/home-manager/blob/master/modules/services/mpd.nix),
[MPD plugins](https://mpd.readthedocs.io/en/stable/plugins.html),
[Fastfetch logos](https://github.com/fastfetch-cli/fastfetch/wiki/Logo-options).
Home Manager option compatibility was checked against the locally pinned input,
not inferred from its current default branch.
