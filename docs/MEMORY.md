# Repository Memory

Updated 2026-10-18. Luna cleanup is implemented; review/merge is pending.
Plan, commits, selections, and validation: [luna-migration.md](luna-migration.md).
Remaining unrelated backlog: [todo-audit.md](todo-audit.md).

## Local writing checks

- The user confirmed the Saguaro fixes work, then requested LTeX in LazyVim
  for English/Norwegian. They explicitly chose local checks rather than sending
  Norwegian documents to LanguageTool's hosted API.
- New feature review bookmark: codex/ltex-local, descending from the cleanup
  branch. Do not interpret the successful activation report as approval to
  move main; the existing review gate remains.
- dotfiles/nvim/lua/plugins/ltex-ls.lua enables the Nix ltex-ls-plus through
  LazyVim's ltex_plus server with mason=false and an empty HTTP server URI.
- config/writing.lua provides buffer-local WritingLanguage en/nb modes:
  English grammar plus bilingual spelling by default; Norwegian Bokmål
  spelling with only LTeX English diagnostics hidden in nb mode.
- No offline Norwegian grammar is claimed. LTeX's duplicate English spelling
  rule is disabled; Neovim handles spelling and personal dictionaries.
- modules/features/dotfiles.nix pins official nb spell/suggestion files
  in Home Manager's nvim/site/spell. Keep personal *.add files unmanaged.
- Actual headless LazyVim English grammar, language-mode switching, and
  English/Norwegian spelling tests passed. See writing.md for usage.

## Workflow and review gate

- Use jj, one commit per logical change. Review bookmark: `codex/luna-cleanup`.
- Its series includes prior commits `98d38bb7` (Darwin/Luna baseline) and
  `c2806e65` (initial TODO fixes), followed by the migration-plan steps.
- main remains `ef1d2195`. Do not merge until the user reviews and approves.
- After approval, fast-forward local main to the reviewed descendant using jj;
  preserve the individual commits. No remote push is authorized.
- The user built and attempted Saguaro activation after the cleanup. It stopped
  at Homebrew because qBittorrent/Xournal++ casks were disabled. Later stages
  may not have run; rerun the switch after the fixes below.

## Architecture

- flake.nix uses flake-parts and `inputs.import-tree ./modules`.
- Nix files in modules register `flake.modules.<class>.<feature>`; data and
  checks that are ordinary Nix expressions belong outside that import tree.
- modules/flake: inputs, aliases, formatter, devshells, profile-policy check.
- modules/features: Home Manager/Darwin/NixOS features; modules/profiles:
  role composition; modules/users: kaktus account/Home Manager composition.
- modules/hosts/targets.nix constructs Saguaro/Luna (aarch64-darwin), Cholla
  (aarch64-linux Asahi), Fishhook (x86_64-linux Proxmox LXC).
- perSystem outputs are restricted to those three architectures.
- archive/unused-modules is inactive. Preserve existing stateVersion values.

## Package ownership and profiles

- Ordinary macOS GUI apps: Homebrew casks. Nix: CLI/configuration/services.
- Home Manager Ghostty, Zed, VSCodium, and Brave Origin use package=null on
  Darwin, retain settings, and install native packages on Linux when selected.
- Use programs.brave-origin, not programs.chromium with a renamed package;
  this preserves the correct native browser extension directory.
- Nix GUI exceptions: JetBrains/plugin wrappers; optional Spicetify/Spotify;
  optional Tenacity because no matching cask exists in the pinned input;
  optional qBittorrent/Xournal++ because their macOS casks are disabled.
  AeroSpace is managed by its nix-darwin service.
- profile-cli: CLI tools, Git/jj, shell, Neovim, nh, monitoring, fonts.
- profile-dev: dev-tools, editor-runtime, YubiKey CLI, LanguageTool, LLM CLI,
  editor/IDE settings, container CLI. Language toolchains are not global.
- profile-desktop (Home Manager): Ghostty config, GPU monitor, daily Linux
  apps, Syncthing. profile-darwin: darwin-tools and Brave Origin config.
- Removed home-packages and darwin-packages. Replacements include cli-tools,
  dev-tools, editor-runtime, personal-tools, security-tools, yubikey,
  desktop-apps, desktop-extra-apps, creative-apps, darwin-tools, gpu-monitor.
- profile-extras (Home Manager): personal/security tools, optional Linux apps,
  Tenacity/mpv, MPD. profile-darwin-extras adds Spicetify and Lima/QEMU.
- darwin.profile-extras composes apps-* groups and optional UTM. Saguaro opts
  into it and both HM extras; Cholla opts into common HM extras.
- Luna imports profile-laptop and gets 16 daily casks, no App Store dependency,
  no optional games/peripheral apps, and no MPD/Spotify/extra VM tools.
- OrbStack is the default macOS runtime; Docker CLI/lazydocker remain Nix.
  macOS Tailscale is the standalone cask, without a Darwin tailscaled service.
- Brew activation uses cleanup=none, autoUpdate=false, upgrade=false.
  This does not disable individual applications' own update mechanisms.
- xcodes and macpm are CLI tools, retained in Nix. GPU monitors are desktop-only.
- The old Spotify DMG overlay was removed; use the pinned native nixpkgs package.
- Catppuccin Mocha data lives in assets/themes/catppuccin-mocha.nix, avoiding
  a base16-schemes build during evaluation. The colors match the old pinned data.

## Project environments

modules/flake/project-shells.nix exports go, rust, jvm, python, web, infra, c.
Use `nix develop ~/nix-config#NAME`; a project's own lock is preferable when
it needs independent version pins. Python uses stable python3, not global
python315. Node/Lua/native compiler/TeX remain available for Neovim plugins.

## Verification and migration requirements

- Strict no-IFD Luna/Saguaro derivation evaluation passed; Luna build dry-run
  passed. No full Luna binary build or activation has been performed.
- Native `nix flake check --no-build` passed; profile-policy evaluated and built.
- All 21 named shells evaluated across the three supported architectures.
- Fishhook system and Cholla Home Manager derivations evaluated.
- Cholla's full system still fails its host-specific Asahi firmware-location
  assertion on this Mac. Root filesystems are configured.
- Optional Proton Mail Desktop and Proton Pass are unavailable on aarch64-linux;
  the optional desktop feature reports and skips unsupported packages.
- Remaining upstream warnings: renamed Rofi font option and options.json
  source context. These are not locally suppressed.
- Before Luna activation: install Determinate Nix (nix.enable=false), create
  kaktus, clone under ~/nix-config for out-of-store dotfile links, build,
  migrate app data/secrets, then grant macOS permissions and test real hardware.
- Snapshot new files with jj before Git-flake evaluation. nh derives its
  configured path from the target user's home on Linux and Darwin.

## Follow-up fixes after the Saguaro activation attempt

- Repository memory was moved by the user to docs/MEMORY.md; keep that path.
- e6a648cc restores qBittorrent/Xournal++ as optional Nix packages and removes
  their disabled macOS casks. scripts/check-brew-casks.py checks Homebrew's
  actual target-platform disabled status, not merely file existence.
- dc25feb4 removes the competing Zsh devenv auto-activation hook and introduces
  managed direnv stdlib. 357992ef makes devenv initialization lazy, because its
  helper names overlap nix-direnv's helpers. Keep use_flake working by loading
  devenv direnvrc only when use_devenv is called.
- The user's old ~/.config/direnv/direnvrc called removed `devenv direnv-hook`.
  It was backed up to direnvrc.before-devenv-fix-20261018-015900 and replaced
  with the generated lazy integration. Real `direnv exec ... true` loaded this
  repository, renewed its cache, and completed all four startup tasks.
- afff75ae restores scheme slug catppuccin-mocha; theme colors are unchanged.
- All 48 Saguaro and 16 Luna casks pass actual Homebrew availability checks. The corrected Saguaro system built without
  activation. The final documentation commit records the remaining checks.
- A private FlakeHub cache returned HTTP 401 during verification, but fallback
  to cache.nixos.org/local builds succeeded. Do not treat that as a direnv API
  failure or disable global authentication settings as part of this fix.
- Main remains unchanged pending review; follow-up commits stay on the review
  bookmark. No activation retry was performed by the assistant.
