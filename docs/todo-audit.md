# Remaining proposals and target-host checks

Reviewed 2026-10-29. Completed refactors and their old commit/check inventories
are recorded in Git history. This page retains unresolved ideas without
presenting them as active configuration.

## Integrations

- **Atuin:** choose which widget owns Ctrl-R in both vi modes; retain fzf for
  file/directory selection. Choose synchronization and key storage before
  enabling remote sync. Verify recording, searches, and terminal restarts.
- **VSCodium MCP:** choose servers, transports, and tasks before adding config.
  Use the pinned Home Manager schema and Nix-owned executables; supply
  credentials at runtime. Verify an actual server task from the editor.
- **Finder desktop grid:** reproduce the desired arrangement on the target
  macOS release and compare preferences/metadata before declaring settings.
  Verify after restarting Finder/login.
- **MPD playback:** test real playback and launchd on the target Mac. Cholla's
  tracked modules do not explicitly configure an audio server; determine the
  actual desktop audio setup before adding PipeWire/PulseAudio services.
  Darwin MPD uses manual database updates because its build lacks inotify.
- **YubiKey:** validate physical PIV/OTP/SSH workflows on target hosts. No new
  Linux smart-card service is enabled by this configuration.
- **Norwegian grammar:** local English grammar and bilingual spelling are
  implemented; offline Bokmål grammar is not. See [writing.md](writing.md).
  Optional n-gram corpora remain deferred.

## Project ideas

| Idea | Next step |
| --- | --- |
| [Kanata](https://github.com/jtroo/kanata) | Define layout/coexistence with Karabiner; test startup, modifiers, typing, and recovery on one host. |
| [nix-topology](https://oddlama.github.io/nix-topology/) | Add explicit external/Darwin nodes and compare a generated diagram with the actual network. |
| Custom packages/perSystem | Add derivations/wrappers only for concrete needs; retain service/configuration modules at their own layer. Consider [nix-wrapper-modules](https://birdeehub.github.io/nix-wrapper-modules/md/getting-started.html). |
| [Terranix](https://terranix.org/) | No tracked HCL project exists here; identify the infrastructure repository and require an unchanged plan for a trial conversion. |
| Devshell templates | Reuse the seven named shells; create standalone templates when a project needs independently pinned versions. |
| Pure direnv | Compare entry time and equivalent scripts/hooks before replacing devenv. Quieter output is a separate choice. |

## Archived material

Keep `archive/unused-modules` unchanged. Its Vesktop theme and Zen browser
bookmark/cookie issues need rechecking if revived. Karabiner automatic backups,
alternate wallpapers, and the inactive SketchyBar files are retained because
absence from current imports alone does not establish that they are unwanted.

Use the [README validation commands](../README.md#development-and-validation)
after changing selections or inputs. Historic cask counts and migration results
are not validation of the current checkout.
