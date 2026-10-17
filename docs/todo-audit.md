# TODO/FIXME audit

Updated 2026-10-18 after the Luna migration cleanup. The initial audit was
committed as c2806e65; [luna-migration.md](luna-migration.md) records the newer
implementation, commit sequence, and verification. The `todo` package is an
application, not a source annotation.

## Addressed

| Original item | Current resolution |
| --- | --- |
| Darwin networking extraction | Dedicated Darwin networking feature, imported by the base profile. |
| Spicetify setting in the user module | Owned by the optional Spicetify feature, with an overridable Stylix default. |
| Missing aliases and vi bindings | Home Manager vi keymap; OS-correct rebuild/open aliases. Project-language aliases require the corresponding shell. |
| Git alias placement | Git aliases stay with their tools; moved Git/jj into the CLI profile. |
| GUI apps mixed into home-packages | Removed the catchall. Native Darwin apps use pinned casks; Linux desktop apps use Nix. See the migration document for exceptions. |
| Global language tools | Seven project shells; editor support runtimes are explicit exceptions. |
| YubiKey feature | Dedicated CLI feature plus Darwin authenticator cask. Physical PIV/OTP/SSH workflows still need target-host checks; no new Linux smart-card service was enabled. |
| Conditional Ollama | The upstream module gates its service. Only an overridable disabled default remains. |
| GPU monitor portability | Dedicated desktop-only gpu-monitor chooses Apple/Linux packages. CLI servers do not inherit GPU packages. |
| MPD FIXME | OS-specific outputs, activation directories, private visualizer FIFO shared with ncmpcpp, obsolete options removed. MPD is optional, not part of Luna's initial profile. |
| Fastfetch logo | Automatic built-in logo selection; generated configuration rendered successfully. |
| Devshell ergonomics | Platform-correct napply and named toolchains; supported output systems are explicit. |
| Fragile palette/Spotify setup discovered during verification | Local pinned color data removes evaluation-time builds. Dropped the mutable macOS Spotify overlay; pinned nixpkgs already provides the native package. |

## Remaining proposals

### Atuin

The old comment called it `autin`. Create an optional Atuin feature, choose
which widget owns Ctrl-R in both vi modes, and retain fzf for file/directory
selection. Choose synchronization server/account/key storage before enabling
remote sync. Verify recording, searches, and terminal restarts before importing
history. Atuin is not enabled by this migration.

### VSCodium MCP

The comment remains in modules/features/vscodium.nix. Choose actual servers,
transports, and intended tasks before adding configuration. Use the pinned
Home Manager schema and Nix-owned executables; provide credentials through
runtime environment variables. Completion means the chosen server starts
from the editor and performs its intended task, not an empty MCP object.

### Finder desktop grid

The old preferences block is disabled. Reproduce the desired arrangement on
the target macOS release, compare preferences before/after the UI change,
and determine whether Finder stores it in preferences or folder metadata.
Add only the observed configuration; verify after restarting Finder/login.

### MPD playback

Startup/status passed in isolation, but playback and launchd need target-host
testing. Cholla does not explicitly enable an audio server in its tracked
host modules. If none is provided elsewhere, configure PipeWire, its PulseAudio
compatibility service, and rtkit in the desktop profile, then test a real track.
Darwin's installed MPD lacks inotify: trigger database updates manually.

## README backlog

| Item | Next step and completion check |
| --- | --- |
| Kanata | Specify a key layout and coexistence with Karabiner; test normal typing, modifiers, startup, and recovery on one host before rollout. [Upstream](https://github.com/jtroo/kanata). |
| nix-topology | Add its NixOS integration plus explicit external/Darwin nodes; build an SVG and compare it with the real network. [Documentation](https://oddlama.github.io/nix-topology/). |
| Custom packages/perSystem | Named shells are implemented. Add perSystem.packages only for actual custom derivations/wrappers; keep service/configuration modules at their own layer. No custom package requiring migration was identified. |
| Terranix | No tracked Terraform/HCL project exists here. Identify the infrastructure repository, convert one small component, and require a plan with no infrastructure changes before adopting. [Terranix](https://terranix.org/). |
| Devshell templates | Reuse the named shells now; projects needing independent versions should own flakes/locks. Add standalone templates when a concrete project needs them. |
| Pure direnv | Keep devenv while its default shell still provides scripts and Git hooks. Benchmark entry time and prototype equivalent mkShell behavior before replacing it. Quieter output is a separate configuration choice. |
| LanguageTool/Neovim/Norwegian | ltex-ls-plus is installed, but ltex-ls.lua remains commented out. Activate ltex_plus through lsp.lua using the Nix executable. Test English locally first. LTeX+ documents Bokmaal only through its online service; choose explicitly between that and local Neovim Norwegian spell files. Test Markdown and Typst diagnostics. [Language support](https://ltex-plus.github.io/ltex-plus/supported-languages.html). |

## Inactive annotations

These modules are archived outside the import tree, or are commented Lua.

| Location | Fix if revived |
| --- | --- |
| archive/unused-modules/darwin/default.nix: SOPS | Check secret paths, activation ordering, and decryption on the intended host; keep private keys out of the store. |
| archive/unused-modules/home/vesktop.nix: Stylix accent | Use the pinned Stylix/Vesktop interface and palette; check generated theme and app appearance. |
| archive/unused-modules/home/zen-browser.nix: bookmarks | Specify the tree and reconcile existing profile data before enabling declarative bookmarks. |
| Same file: upstream browser issue | Recheck the issue against the selected version and reproduce before removing the fallback browser. |
| Same file: cookies | Inspect policies/preferences and test restart persistence with a disposable profile first. |
| dotfiles/nvim/lua/plugins/ltex-ls.lua: lsp.lua | Included in the active LanguageTool proposal above. |
| Same file: n-gram data | Defer until the server works; select/provision a supported corpus outside Git and compare diagnostics/performance. This does not add Norwegian support to local LanguageTool. |

## Verification

See [the migration verification](luna-migration.md#verification) for current
host, shell, ownership-check, and build dry-run results. Full Luna binary
build/activation and physical hardware/app integration remain migration steps.
