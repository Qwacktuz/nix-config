# LLM Refactor Instructions: Dendritic Nix Flake Restructure

You are refactoring an existing personal Nix flake into a cleaner **full dendritic design** using:

- `flake-parts`
- `import-tree` / recursive module imports
- inline flake-parts modules
- `flake.modules.<moduleClass>.<name>` for reusable modules
- support for multiple hosts and architectures:
  - `aarch64-linux`
  - `x86_64-linux`
  - `aarch64-darwin`
- NixOS, nix-darwin, and Home Manager integration

The user wants `modules/` to be the recursively imported flake-parts module tree. Every `.nix` file inside the recursive import tree should be a valid flake-parts module unless it is deliberately placed in an ignored/private path such as `/_`.

The current repository is approximately:

```text
nix-config/
├── dotfiles/
├── modules/
│   ├── darwin/
│   ├── home/
│   ├── hosts/
│   ├── nixos/
│   ├── packages/
│   ├── users/
│   ├── devenv.nix
│   ├── fonts.nix
│   ├── inputs.nix
│   ├── meta.nix
│   ├── nixpkgs.nix
│   ├── ssh.nix
│   ├── tailscale.nix
│   └── targets.nix
├── pubkeys/
├── secrets/
├── flake.nix
└── README.md
```

## Primary objective

Refactor `modules/` into a cleaner dendritic structure where files are organized by **dendritic role**:

```text
modules/
├── flake/       # global flake-parts config and outputs
├── hosts/       # concrete host outputs
├── hardware/    # host-specific or hardware-family modules
├── features/    # reusable features across module classes
├── profiles/    # bundles of features
├── users/       # user/home-manager composition
└── packages/    # perSystem package output declarations
```

Keep non-module implementation/data outside the recursive import tree:

```text
packages/        # raw derivations
dotfiles/        # raw dotfiles linked by Home Manager
assets/          # wallpapers/static files
pubkeys/         # public keys
secrets/         # encrypted secrets
```

If private helper files are needed inside `modules/`, place them under ignored `/_` paths, for example:

```text
modules/hosts/_shared/mk-nixos-host.nix
modules/hosts/_shared/mk-darwin-host.nix
modules/features/_impl/
```

Do not assume every proposed move is correct. Read the actual files first and adapt the structure when the code suggests a better placement.

---

## Important constraints

1. `flake.nix` should remain small.
2. The flake should be composed through `flake-parts`.
3. `modules/` should be recursively imported with `import-tree`.
4. Files directly imported by `import-tree` should be inline flake-parts modules.
5. Use `flake.modules.<class>.<name>` for reusable modules.
6. Still expose standard outputs where practical:
   - `nixosConfigurations`
   - `darwinConfigurations`
   - `homeManagerModules`
   - `nixosModules`
   - `darwinModules`
   - `packages`
   - `devShells`
   - `checks`
   - `formatter`
7. Home Manager should own user-level config.
8. NixOS should own Linux system-level config.
9. nix-darwin should own macOS system-level config.
10. `perSystem` should own packages, apps, checks, formatters, and dev shells.
11. Host files should remain concrete and thin.
12. Features should be reusable.
13. Profiles should bundle features.
14. Hardware configs should be host-specific or hardware-family-specific.
15. Avoid importing Darwin-only modules into NixOS and NixOS-only modules into Darwin.

---

## Compatibility and verification instructions

Before changing anything, inspect:

```bash
tree . --ignore-glob data --git-ignore
sed -n '1,220p' flake.nix
find modules -maxdepth 3 -type f -name '*.nix' | sort
```

Then inspect enough module contents to understand the current architecture:

```bash
sed -n '1,220p' modules/targets.nix
sed -n '1,220p' modules/hosts/core.nix
sed -n '1,220p' modules/hosts/cholla.nix
sed -n '1,220p' modules/hosts/saguaro.nix
sed -n '1,220p' modules/hosts/fishhook.nix
```

Also inspect representative files from each category:

```bash
sed -n '1,220p' modules/home/git.nix
sed -n '1,220p' modules/home/packages.nix
sed -n '1,220p' modules/home/dotfiles.nix
sed -n '1,220p' modules/darwin/darwin-config.nix
sed -n '1,220p' modules/darwin/homebrew.nix
sed -n '1,220p' modules/nixos/nixos-config.nix
sed -n '1,220p' modules/users/kaktus.nix
sed -n '1,220p' modules/nixpkgs.nix
```

After each meaningful refactor step, run the most relevant checks available in the repository:

```bash
nix flake show
nix flake check --show-trace
```

Build host configs without switching where possible:

```bash
nix build .#nixosConfigurations.cholla.config.system.build.toplevel --show-trace
nix build .#nixosConfigurations.fishhook.config.system.build.toplevel --show-trace
nix build .#darwinConfigurations.saguaro.system --show-trace
```

If an output name differs, inspect `nix flake show` and adjust.

If a check fails, stop and analyze the failure. Do not continue moving files blindly.

---

## Current-to-target mapping

Use this as the initial guess, not as a strict law. Verify by reading the file contents.

### Existing `modules/home/*.nix`

Most of these are Home Manager features and should become `modules/features/*.nix` or `modules/profiles/*.nix`.

Suggested mapping:

```text
modules/home/git.nix              -> modules/features/git.nix
modules/home/zsh.nix              -> modules/features/zsh.nix
modules/home/zsh_alias.nix        -> modules/features/zsh-aliases.nix
modules/home/starship.nix         -> modules/features/starship.nix
modules/home/bat.nix              -> modules/features/bat.nix
modules/home/btop.nix             -> modules/features/btop.nix
modules/home/direnv.nix           -> modules/features/direnv.nix
modules/home/fzf.nix              -> modules/features/fzf.nix
modules/home/fastfetch.nix        -> modules/features/fastfetch.nix
modules/home/micro.nix            -> modules/features/micro.nix
modules/home/nh.nix               -> modules/features/nh.nix
modules/home/syncthing.nix        -> modules/features/syncthing.nix
modules/home/vscodium.nix         -> modules/features/vscodium.nix
modules/home/zed.nix              -> modules/features/zed.nix
modules/home/jetbrains.nix        -> modules/features/jetbrains.nix
modules/home/music.nix            -> modules/features/music.nix
modules/home/prismlauncher.nix    -> modules/features/prismlauncher.nix
modules/home/spicetify.nix        -> modules/features/spicetify.nix
modules/home/languagetool.nix     -> modules/features/languagetool.nix
modules/home/llm.nix              -> modules/features/llm.nix
modules/home/dotfiles.nix         -> modules/features/dotfiles.nix
modules/home/packages.nix         -> modules/profiles/home-packages.nix or modules/features/home-packages.nix
modules/home/darwin-packages.nix  -> modules/profiles/home-darwin.nix or split into features
```

If a file merely enables a program, make it a feature.

If a file is a broad package bundle, consider turning it into a profile.

If a file contains Darwin-only Home Manager config, either:
- keep it as a Home Manager feature with Darwin guards, or
- move it to a `home-darwin` profile.

### Existing `modules/darwin/*.nix`

These are probably nix-darwin features, Darwin profiles, or host-adjacent system config.

Suggested mapping:

```text
modules/darwin/darwin-config.nix   -> modules/profiles/darwin-base.nix or modules/features/darwin-system.nix
modules/darwin/homebrew.nix        -> modules/features/homebrew.nix
modules/darwin/aerospace.nix       -> modules/features/aerospace.nix
modules/darwin/stylix.nix          -> modules/features/stylix.nix
modules/darwin/virtualization.nix  -> modules/features/darwin-virtualization.nix or modules/features/virtualization.nix
```

Move images out of `modules/darwin/`:

```text
modules/darwin/background-onIce.jpg -> assets/wallpapers/background-onIce.jpg
modules/darwin/love_lain.jpg        -> assets/wallpapers/love_lain.jpg
```

If any `_unused` modules are useful, migrate them. Otherwise leave under ignored paths or move to an archive outside the import tree.

### Existing `modules/nixos/*.nix`

Suggested mapping:

```text
modules/nixos/nixos-config.nix -> modules/profiles/nixos-base.nix or modules/features/nixos-system.nix
```

If it configures desktop, graphics, boot, users, services, etc., consider splitting into features or profiles.

### Existing `modules/hosts/*.nix`

These are concrete host outputs or host modules.

Suggested mapping:

```text
modules/hosts/cholla.nix   -> modules/hosts/cholla.nix
modules/hosts/saguaro.nix  -> modules/hosts/saguaro.nix
modules/hosts/fishhook.nix -> modules/hosts/fishhook.nix
modules/hosts/core.nix     -> modules/hosts/_shared/core.nix or split into profiles/features
```

The exact host files may already be flake-parts modules. Preserve that style.

Host files should construct:

```nix
flake.nixosConfigurations.<host>
```

or:

```nix
flake.darwinConfigurations.<host>
```

They should import profiles/features from `config.flake.modules`.

### Existing root-level modules

Suggested mapping:

```text
modules/devenv.nix   -> modules/flake/devshells.nix
modules/fonts.nix    -> modules/features/fonts.nix
modules/inputs.nix   -> modules/flake/inputs.nix or keep if already valid
modules/meta.nix     -> modules/flake/meta.nix
modules/nixpkgs.nix  -> modules/flake/nixpkgs.nix or modules/features/nixpkgs.nix
modules/ssh.nix      -> modules/features/ssh.nix
modules/tailscale.nix -> modules/features/tailscale.nix
modules/targets.nix  -> modules/hosts/_shared/targets.nix or modules/flake/targets.nix
```

Be careful with `targets.nix`: if it is a plain data file, move it to an ignored private path like:

```text
modules/hosts/_shared/targets.nix
```

or outside `modules/`, because plain data files should not be recursively imported as flake-parts modules.

---

## Target directory shape

Aim for this end state:

```text
modules/
├── flake/
│   ├── systems.nix
│   ├── inputs.nix
│   ├── meta.nix
│   ├── nixpkgs.nix
│   ├── module-aliases.nix
│   ├── devshells.nix
│   ├── checks.nix
│   └── formatter.nix
│
├── hosts/
│   ├── cholla.nix
│   ├── saguaro.nix
│   ├── fishhook.nix
│   └── _shared/
│       ├── targets.nix
│       ├── mk-nixos-host.nix
│       └── mk-darwin-host.nix
│
├── hardware/
│   ├── cholla.nix
│   ├── fishhook.nix
│   └── _generated/
│       └── README.md
│
├── features/
│   ├── aerospace.nix
│   ├── bat.nix
│   ├── btop.nix
│   ├── direnv.nix
│   ├── dotfiles.nix
│   ├── fastfetch.nix
│   ├── fonts.nix
│   ├── fzf.nix
│   ├── ghostty.nix
│   ├── git.nix
│   ├── homebrew.nix
│   ├── jetbrains.nix
│   ├── kde-plasma.nix
│   ├── languagetool.nix
│   ├── llm.nix
│   ├── micro.nix
│   ├── music.nix
│   ├── nh.nix
│   ├── nvim.nix
│   ├── prismlauncher.nix
│   ├── ssh.nix
│   ├── starship.nix
│   ├── stylix.nix
│   ├── syncthing.nix
│   ├── tailscale.nix
│   ├── vscodium.nix
│   ├── virtualization.nix
│   ├── zed.nix
│   ├── zsh.nix
│   └── zsh-aliases.nix
│
├── profiles/
│   ├── home-cli.nix
│   ├── home-dev.nix
│   ├── home-desktop.nix
│   ├── home-linux.nix
│   ├── home-darwin.nix
│   ├── nixos-base.nix
│   ├── nixos-desktop.nix
│   ├── nixos-server.nix
│   ├── nixos-vm.nix
│   ├── darwin-base.nix
│   ├── darwin-desktop.nix
│   └── darwin-laptop.nix
│
├── users/
│   ├── kaktus.nix
│   └── user.nix
│
└── packages/
    ├── languagetool-wrapper.nix
    └── write-flake.nix
```

---

## Dendritic module style

Each file under `modules/features/` should be an inline flake-parts module that registers one or more reusable modules.

Example Home Manager-only feature:

```nix
# modules/features/git.nix
{
  flake.modules.homeManager.git = {
    programs.git.enable = true;
  };
}
```

Example NixOS-only feature:

```nix
# modules/features/kde-plasma.nix
{
  flake.modules.nixos.kde-plasma = {
    services.xserver.enable = true;
    services.displayManager.sddm.enable = true;
    services.desktopManager.plasma6.enable = true;
  };
}
```

Example Darwin-only feature:

```nix
# modules/features/homebrew.nix
{
  flake.modules.darwin.homebrew = {
    homebrew.enable = true;
  };
}
```

Example cross-class feature:

```nix
# modules/features/tailscale.nix
{
  flake.modules.nixos.tailscale = {
    services.tailscale.enable = true;
  };

  flake.modules.darwin.tailscale = {
    # Darwin-specific tailscale config, if applicable.
  };

  flake.modules.homeManager.tailscale = {
    # Optional user-level tailscale helpers, aliases, shell integration, etc.
  };
}
```

If the existing modules use custom options, preserve them unless there is a clear reason to simplify. If they do not, consider introducing options gradually rather than all at once.

---

## Profile style

Profiles should be reusable bundles of features.

Example:

```nix
# modules/profiles/home-cli.nix
{ config, ... }:

{
  flake.modules.homeManager.profile-cli = {
    imports = [
      config.flake.modules.homeManager.git
      config.flake.modules.homeManager.zsh
      config.flake.modules.homeManager.starship
      config.flake.modules.homeManager.bat
      config.flake.modules.homeManager.fzf
    ];
  };
}
```

Example NixOS desktop profile:

```nix
# modules/profiles/nixos-desktop.nix
{ config, ... }:

{
  flake.modules.nixos.profile-desktop = {
    imports = [
      config.flake.modules.nixos.kde-plasma
      config.flake.modules.nixos.tailscale
    ];

    # Other desktop-level NixOS config can go here.
  };
}
```

Example Darwin desktop profile:

```nix
# modules/profiles/darwin-desktop.nix
{ config, ... }:

{
  flake.modules.darwin.profile-desktop = {
    imports = [
      config.flake.modules.darwin.homebrew
      config.flake.modules.darwin.aerospace
    ];
  };
}
```

Do not put NixOS-only features into Darwin profiles or Darwin-only features into NixOS profiles.

---

## Host style

Hosts should be concrete outputs.

Example NixOS host:

```nix
# modules/hosts/cholla.nix
{ inputs, config, ... }:

{
  flake.nixosConfigurations.cholla =
    inputs.nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";

      specialArgs = {
        inherit inputs;
      };

      modules = [
        inputs.home-manager.nixosModules.home-manager

        config.flake.modules.nixos.profile-desktop
        config.flake.modules.nixos.hardware-cholla

        {
          networking.hostName = "cholla";

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.kaktus = {
            imports = [
              config.flake.modules.homeManager.user-kaktus
              config.flake.modules.homeManager.profile-cli
              config.flake.modules.homeManager.profile-dev
              config.flake.modules.homeManager.profile-linux
            ];
          };
        }
      ];
    };
}
```

Example Darwin host:

```nix
# modules/hosts/saguaro.nix
{ inputs, config, ... }:

{
  flake.darwinConfigurations.saguaro =
    inputs.darwin.lib.darwinSystem {
      system = "aarch64-darwin";

      specialArgs = {
        inherit inputs;
      };

      modules = [
        inputs.home-manager.darwinModules.home-manager

        config.flake.modules.darwin.profile-desktop

        {
          networking.hostName = "saguaro";

          users.users.kaktus.home = "/Users/kaktus";

          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.kaktus = {
            imports = [
              config.flake.modules.homeManager.user-kaktus
              config.flake.modules.homeManager.profile-cli
              config.flake.modules.homeManager.profile-dev
              config.flake.modules.homeManager.profile-darwin
            ];
          };
        }
      ];
    };
}
```

Adapt these examples to the actual repository. Do not overwrite working host logic without understanding it.

---

## Users

`modules/users/kaktus.nix` should ideally register a reusable Home Manager module:

```nix
# modules/users/kaktus.nix
{
  flake.modules.homeManager.user-kaktus = {
    home.username = "kaktus";

    # Use the correct path per host if needed.
    # Prefer setting home.homeDirectory in host files when it differs by platform.
  };
}
```

If `user.nix` defines system-level user creation, decide whether it belongs as:

```text
modules/features/user-kaktus.nix
```

or should remain in:

```text
modules/users/user.nix
```

The distinction:

```text
Home Manager user config -> flake.modules.homeManager.user-kaktus
System user creation     -> flake.modules.nixos.user-kaktus or flake.modules.darwin.user-kaktus
```

---

## Hardware

Host-specific hardware should be explicit:

```nix
# modules/hardware/cholla.nix
{
  flake.modules.nixos.hardware-cholla = {
    # hardware-specific NixOS config
  };
}
```

If hardware config is generated by `nixos-generate-config`, either inline it here or keep an ignored implementation file:

```text
modules/hardware/cholla.nix
modules/hardware/_cholla/hardware-configuration.nix
```

Then:

```nix
# modules/hardware/cholla.nix
{
  flake.modules.nixos.hardware-cholla = {
    imports = [
      ./_cholla/hardware-configuration.nix
    ];
  };
}
```

Only do this if ignored `/_` files are compatible with the import-tree behavior.

---

## Packages

`modules/packages/*.nix` should declare `perSystem.packages`.

Example:

```nix
# modules/packages/languagetool-wrapper.nix
{
  perSystem = { pkgs, ... }: {
    packages.languagetool-wrapper =
      pkgs.callPackage ../../packages/languagetool-wrapper { };
  };
}
```

The raw derivation should live outside the recursive import tree:

```text
packages/languagetool-wrapper/default.nix
```

---

## Public aliases

Add a module to expose standard outputs from the dendritic registry:

```nix
# modules/flake/module-aliases.nix
{ config, ... }:

{
  flake.homeManagerModules = config.flake.modules.homeManager;
  flake.nixosModules = config.flake.modules.nixos;
  flake.darwinModules = config.flake.modules.darwin;
}
```

If this conflicts with current flake-parts behavior, inspect the error and adapt.

---

## Suggested migration order

Use small commits. Do not perform the whole migration in one opaque step.

1. Confirm how `flake.nix` currently imports `modules/`.
2. Confirm whether all current `modules/**/*.nix` files are valid flake-parts modules.
3. Create the target directories:
   - `modules/flake`
   - `modules/hosts`
   - `modules/hosts/_shared`
   - `modules/hardware`
   - `modules/features`
   - `modules/profiles`
   - `modules/users`
   - `modules/packages`
4. Move only obviously global flake-parts modules first:
   - `devenv.nix`
   - `inputs.nix`
   - `meta.nix`
   - `nixpkgs.nix`
5. Run `nix flake check --show-trace`.
6. Move Home Manager feature modules from `modules/home/` into `modules/features/`.
7. Preserve their behavior by registering them under `flake.modules.homeManager.<name>`.
8. Run checks/builds.
9. Move Darwin system modules into `modules/features/` and register under `flake.modules.darwin.<name>`.
10. Run checks/builds.
11. Move NixOS system modules into `modules/features/` and register under `flake.modules.nixos.<name>`.
12. Run checks/builds.
13. Create profile modules:
    - `home-cli`
    - `home-dev`
    - `home-desktop`
    - `home-linux`
    - `home-darwin`
    - `nixos-desktop`
    - `nixos-server`
    - `nixos-vm`
    - `darwin-desktop`
14. Refactor hosts to import profiles instead of long feature lists.
15. Move hardware-specific configs into `modules/hardware/`.
16. Move wallpapers/images out of `modules/` into `assets/wallpapers/`.
17. Move plain data/helper files under ignored paths or outside `modules/`.
18. Add public module aliases.
19. Run final verification:
    - `nix flake show`
    - `nix flake check --show-trace`
    - host builds for cholla, fishhook, and saguaro.

---

## Decision guidance

When deciding where a file belongs, use this table:

| Type of file | Destination |
|---|---|
| Concrete machine output | `modules/hosts/<host>.nix` |
| Host-specific hardware | `modules/hardware/<host>.nix` |
| Reusable Home Manager program config | `modules/features/<feature>.nix` |
| Reusable NixOS service/system config | `modules/features/<feature>.nix` |
| Reusable nix-darwin system config | `modules/features/<feature>.nix` |
| Feature with both HM and system config | `modules/features/<feature>.nix` |
| Bundle of features | `modules/profiles/<profile>.nix` |
| User composition | `modules/users/<user>.nix` |
| Dev shell/checks/formatter/systems | `modules/flake/<thing>.nix` |
| perSystem package output | `modules/packages/<package>.nix` |
| Raw package derivation | `packages/<package>/default.nix` |
| Dotfiles | `dotfiles/` |
| Wallpapers/static files | `assets/` |
| Secrets | `secrets/` |
| Public keys | `pubkeys/` |
| Helper functions/plain data | outside recursive import tree or under ignored `/_` |

---

## Important examples

### Cross-platform feature: Git

Git should be a Home Manager feature used by all machines:

```text
modules/features/git.nix
```

It should be included in:

```text
modules/profiles/home-cli.nix
```

Then all hosts can get Git by importing `profile-cli`.

### Platform-specific feature: KDE Plasma

KDE Plasma should be NixOS-only:

```text
modules/features/kde-plasma.nix
```

Register it as:

```nix
flake.modules.nixos.kde-plasma = { ... };
```

Use it only in:

```text
modules/profiles/nixos-desktop.nix
```

Never import it into Darwin hosts.

### Platform-specific feature: Homebrew

Homebrew should be Darwin-only:

```text
modules/features/homebrew.nix
```

Register it as:

```nix
flake.modules.darwin.homebrew = { ... };
```

Use it in:

```text
modules/profiles/darwin-desktop.nix
```

### Cross-class feature: Syncthing

Syncthing may need both Home Manager and system-level modules:

```text
modules/features/syncthing.nix
```

It can expose:

```nix
flake.modules.homeManager.syncthing = { ... };
flake.modules.nixos.syncthing = { ... };
flake.modules.darwin.syncthing = { ... };
```

Use only the relevant class in each profile.

---

## Expected final characteristics

At the end, the flake should have:

```text
modules/
  recursively imported inline flake-parts modules

features/
  reusable feature definitions

profiles/
  reusable bundles

hosts/
  thin concrete machine outputs

hardware/
  host-specific hardware

users/
  user/home-manager composition

packages/
  perSystem package output declarations
```

The flake should support:

```text
cholla    -> NixOS, aarch64-linux, physical machine
saguaro   -> nix-darwin, aarch64-darwin, physical machine
fishhook  -> NixOS, deploy VM target
future    -> x86_64-linux NixOS target
```

The architecture should allow adding a new host mostly by adding:

```text
modules/hosts/<new-host>.nix
modules/hardware/<new-host>.nix
```

and selecting existing profiles/features.

---

## Refactoring philosophy

Do not blindly force the repository into the exact proposed layout if the real code suggests a better split.

Prefer:

```text
small moves
frequent evaluation
preserving behavior
clear class boundaries
standard flake outputs
thin hosts
reusable features
profiles for bundles
```

Avoid:

```text
large one-shot rewrites
moving raw derivations into recursive modules
Darwin/NixOS class mixing
host-specific logic inside reusable features
feature logic inside host files
giant package lists copied between hosts
broken `nix flake show`
```

When unsure, inspect the actual file and suggest the safest migration path before editing.
