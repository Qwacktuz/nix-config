# Final Refactoring Plan

## Design Decisions (Locked In)

| Decision | Choice |
|---|---|
| HM module strategy | DRY variables in single file, per-host extras |
| `darwin-packages.nix` | No `isDarwin` guard — import only on darwin via extras list |
| `system/` directory | **Dissolve** — move contents to where they belong |
| `darwin/` / `nixos/` dirs | **Keep** — for platform-specific *system-level* modules only |
| `virtualization` modules | **Merge** into one file, deduplicate packages |
| Dotfile symlinks (`home.nix`) | Extract into `home/dotfiles.nix`, bound to user |
| `interface.nix` | **Delete** (entirely commented out) |
| `flake-file` / `import-tree` | **Keep** |
| `devenv.nix` hostname | **Parameterize** |

---

## Target Directory Structure

```
modules/
├── inputs.nix              # unchanged
├── meta.nix                # unchanged
├── nixpkgs.nix             # unchanged
├── targets.nix             # unchanged
├── devenv.nix              # parameterize hostname
├── ssh.nix                 # unchanged (defines homeManager.ssh-client + nixos.ssh-server)
├── tailscale.nix           # MOVED from system/ (defines darwin.tailscale + nixos.tailscale)
│
├── hosts/
│   ├── core.nix            # unchanged (generic.core)
│   ├── saguaro.nix         # minor: remove darwin.virtualization import
│   ├── fishhook.nix        # unchanged
│   └── cholla.nix          # unchanged
│
├── users/
│   ├── user.nix            # unchanged
│   └── kaktus.nix          # ⭐ MAJOR REFACTOR: DRY variables
│
├── darwin/                 # darwin-only system modules
│   ├── darwin-config.nix   # parameterize hostname
│   ├── aerospace.nix       # MOVED from system/
│   ├── homebrew.nix        # MOVED from system/
│   ├── stylix.nix          # MOVED from system/
│   └── virtualization.nix  # MERGED from system/virtualization.nix + top-level virtualization.nix
│
├── nixos/
│   └── nixos-config.nix    # unchanged
│
└── home/                   # atomic HM modules (cross-platform by default)
    ├── dotfiles.nix        # NEW (extracted from home.nix)
    ├── packages.nix        # unchanged
    ├── darwin-packages.nix # MODIFIED: remove isDarwin guard
    ├── bat.nix             # unchanged
    ├── btop.nix            # unchanged
    ├── direnv.nix          # unchanged
    ├── fastfetch.nix       # unchanged
    ├── fzf.nix             # unchanged
    ├── git.nix             # unchanged
    ├── jetbrains.nix       # unchanged
    ├── languagetool.nix    # unchanged
    ├── llm.nix             # unchanged
    ├── micro.nix           # unchanged
    ├── music.nix           # unchanged
    ├── nh.nix              # unchanged
    ├── prismlauncher.nix   # unchanged
    ├── spicetify.nix       # unchanged
    ├── starship.nix        # unchanged
    ├── syncthing.nix       # unchanged
    ├── vscodium.nix        # unchanged
    ├── zed.nix             # unchanged
    ├── zsh.nix             # unchanged
    └── zsh_alias.nix       # unchanged
```

### Files Deleted

| File | Reason |
|---|---|
| [interface.nix](file:///Users/kaktus/nix-config/modules/interface.nix) | Entirely commented out, no active code |
| [home.nix](file:///Users/kaktus/nix-config/modules/home.nix) | Content moved to `home/dotfiles.nix` |
| [fonts.nix](file:///Users/kaktus/nix-config/modules/fonts.nix) | Stays as-is (it's already a standalone HM module) |
| [patches.nix.bak](file:///Users/kaktus/nix-config/modules/patches.nix.bak) | Dead backup file |
| [modules/virtualization.nix](file:///Users/kaktus/nix-config/modules/virtualization.nix) | Merged into `darwin/virtualization.nix` |
| [modules/system/](file:///Users/kaktus/nix-config/modules/system) | Entire directory dissolved |

---

## File-by-File Changes

### 1. `users/kaktus.nix` — The core refactor

This is the main change. Define HM module lists **once** as variables:

```nix
{
  inputs,
  self,
  config,
  ...
}:
let
  inherit (config) userName;

  # ── Cross-platform HM modules (imported on ALL hosts) ──────────────
  sharedHmModules = with self.modules.homeManager; [
    ${userName}       # user base config (homeDir, stateVersion — from user.nix)
    dotfiles          # neovim, karabiner, ghostty symlinks

    # Shell & terminal
    zsh
    zsh_alias
    direnv
    starship
    fzf
    bat
    btop

    # Dev tools & editors
    git
    micro
    fastfetch
    nh
    languagetool
    llm
    vscodium
    zed
    jetbrains

    # Packages & services
    packages
    ssh-client
    fonts
    syncthing
    music
  ];

  # ── Darwin-only HM extras (ONLY added to darwin hosts) ─────────────
  darwinHmExtras = with self.modules.homeManager; [
    darwin-packages   # aerospace, stats, iina
    spicetify
    prismlauncher
    virtualization    # orbstack, docker, utm, qemu, lima
  ];

  # ── NixOS-only HM extras (if needed in the future) ─────────────────
  # nixosHmExtras = with self.modules.homeManager; [ ];

  # ── Common home-manager settings ────────────────────────────────────
  hmDefaults = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "bak";
  };
in
{
  # ── Darwin user module ──────────────────────────────────────────────
  flake.modules.darwin.${userName} = {
    imports = [ inputs.home-manager.darwinModules.home-manager ];

    home-manager = hmDefaults // {
      sharedModules = [
        { stylix.targets.spicetify.enable = false; }
      ];
      users.${userName}.imports = sharedHmModules ++ darwinHmExtras;
    };
  };

  # ── NixOS user module ──────────────────────────────────────────────
  flake.modules.nixos.${userName} = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = hmDefaults // {
      users.${userName}.imports = sharedHmModules;
    };
  };
}
```

> [!TIP]
> To add a new HM module to all hosts: add one line to `sharedHmModules`.
> To add a darwin-only HM module: add one line to `darwinHmExtras`.
> To add a new NixOS host: it automatically gets `sharedHmModules` — no duplication.

---

### 2. `home/dotfiles.nix` — New file (extracted from `home.nix`)

```nix
{ ... }:
{
  flake.modules.homeManager.dotfiles =
    { pkgs, config, lib, ... }:
    let
      dotfiles = "${config.home.homeDirectory}/nix-config/dotfiles";
      create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;
    in
    {
      home.enableNixpkgsReleaseCheck = false;
      programs.home-manager.enable = true;

      home.packages = with pkgs; [
        neovim
      ];

      # Cross-platform dotfiles
      xdg.configFile."nvim" = {
        source = create_symlink "${dotfiles}/nvim";
        recursive = true;
      };

      # Darwin-only dotfiles (harmless guard — these paths don't exist on Linux)
      xdg.configFile."karabiner" = lib.mkIf pkgs.stdenvNoCC.isDarwin {
        source = create_symlink "${dotfiles}/karabiner";
        recursive = true;
      };

      home.file."Library/Application Support/com.mitchellh.ghostty" =
        lib.mkIf pkgs.stdenvNoCC.isDarwin {
          source = create_symlink "${dotfiles}/com.mitchellh.ghostty";
          recursive = true;
        };
    };
}
```

> [!NOTE]
> The `isDarwin` guards here are different from the `darwin-packages.nix` case. These guard macOS-specific *filesystem paths* (`Library/Application Support/...`) that would be nonsensical on Linux. It's not a package-availability concern — it's a path-validity concern.

---

### 3. `home/darwin-packages.nix` — Remove isDarwin guard

```diff
 { ... }:
 {
   flake.modules.homeManager.darwin-packages =
     { pkgs, ... }:
     {
-      # home.packages for darwin only
-      home.packages =
-        if pkgs.stdenvNoCC.isDarwin then
-          with pkgs;
-          [
-            aerospace
-            # sketchybar
-            stats
-            iina
-          ]
-        else
-          [
-            # No packages if not on darwin
-          ];
+      # Darwin-only home.packages
+      # This module is ONLY imported by darwin hosts via darwinHmExtras
+      home.packages = with pkgs; [
+        aerospace
+        # sketchybar
+        stats
+        iina
+      ];
     };
 }
```

---

### 4. `darwin/virtualization.nix` — Merged module

Combines the top-level `virtualization.nix` (HM: orbstack, docker, lima, lazydocker, utm, qemu) with `system/virtualization.nix` (darwin system: qemu, utm). Deduplicates utm and qemu.

```nix
{ ... }:
{
  # HM-level: docker CLI, container tools, VM packages
  flake.modules.homeManager.virtualization =
    { pkgs, ... }:
    {
      services.colima.enable = false;

      programs.docker-cli.enable = true;

      home.packages = with pkgs; [
        orbstack       # Docker Desktop replacement
        lima           # Run Linux VMs
        lazydocker     # Docker TUI
        utm            # Virtual machines (GUI)
        qemu           # Virtual machines (CLI)
      ];
    };

  # Darwin system-level: ensure qemu/utm are also available system-wide
  # (Currently a no-op since the same packages are in HM.
  #  Keep this if you want system-level VM access for other users.)
  # flake.modules.darwin.virtualization = {
  #   environment.systemPackages = with pkgs; [ qemu utm ];
  # };
}
```

> [!IMPORTANT]
> The `virtualization` HM module moves to `darwinHmExtras` since orbstack, UTM, and lima are darwin-specific. If you later need Linux VM tools, add a separate `linux-virtualization` HM module.

---

### 5. `darwin/darwin-config.nix` — Parameterize hostname

```diff
-{ self, ... }:
-let
-  # TODO:: refactor into global
-  hostname = "saguaro";
-in
+{ self, config, ... }:
 {
   flake.modules.darwin.darwin-config =
-    { pkgs, ... }:
+    { pkgs, config as darwinConfig, ... }:
+    let
+      hostname = darwinConfig.networking.hostName;
+    in
     {
```

Actually, cleaner approach — just remove the `let hostname` and use the value directly from the host definition. Each host already sets its own `networking.hostName`:

```diff
-{ self, ... }:
-let
-  # TODO:: refactor into global
-  hostname = "saguaro";
-in
+{ self, ... }:
 {
   flake.modules.darwin.darwin-config =
     { pkgs, config, ... }:
     {
+      # networking.hostName is set by each host that imports this module
       nix.extraOptions = ''
         extra-platforms = x86_64-darwin aarch64-darwin
       '';

-      networking = {
-        computerName = hostname;
-        hostName = hostname;
+      networking = {
+        computerName = config.networking.hostName;
```

And in [hosts/saguaro.nix](file:///Users/kaktus/nix-config/modules/hosts/saguaro.nix), add `networking.hostName = "saguaro";` at the host level.

---

### 6. Move `system/*` files to `darwin/`

These are simple file moves with no content changes:

| From | To |
|---|---|
| `system/aerospace.nix` | `darwin/aerospace.nix` |
| `system/homebrew.nix` | `darwin/homebrew.nix` |
| `system/stylix.nix` | `darwin/stylix.nix` |
| `system/tailscale.nix` | `modules/tailscale.nix` (top-level, cross-platform) |
| `system/love_lain.jpg` | `darwin/love_lain.jpg` (referenced by stylix.nix) |
| `system/background-onIce.jpg` | `darwin/background-onIce.jpg` |
| `system/virtualization.nix` | merged into `darwin/virtualization.nix` |
| `system/_unused/` | `darwin/_unused/` or delete |

> [!WARNING]
> After moving `stylix.nix`, its relative path `./love_lain.jpg` will still work because both files move to the same directory. No path changes needed.

---

### 7. `devenv.nix` — Parameterize hostname

```diff
-      scripts.napply.exec = "nh darwin switch .#saguaro";
+      scripts.napply.exec = "nh os switch";
```

Or, if you want to keep the explicit flake ref but make it dynamic, use a function that detects the hostname. The simplest portable approach is `nh os switch` which auto-detects.

---

### 8. `hosts/saguaro.nix` — Set hostname explicitly

```diff
   flake.modules.darwin.saguaro = {
     imports = with self.modules; [
       generic.core
       darwin.darwin-config
       darwin.${config.userName}

       darwin.aerospace
       darwin.homebrew
       darwin.stylix
-      # darwin.virtualization
     ];

+    networking.hostName = "saguaro";
+
     nixpkgs.overlays = [
```

---

### 9. Delete dead files

- `modules/interface.nix` — entirely commented out
- `modules/patches.nix.bak` — dead backup file
- `modules/home.nix` — content moved to `home/dotfiles.nix`
- `modules/virtualization.nix` — merged into `darwin/virtualization.nix`
- `modules/system/` — entire directory (contents moved)

---

## Migration Sequence

The changes should be applied in this order to stay buildable at each step:

1. **Create `home/dotfiles.nix`** (new file, not yet imported)
2. **Refactor `users/kaktus.nix`** (add DRY variables, add `dotfiles` to shared list)
3. **Delete `home.nix`** (dotfiles module now takes over)
4. **Modify `home/darwin-packages.nix`** (remove isDarwin guard)
5. **Merge virtualization modules** into `darwin/virtualization.nix`
6. **Move `system/*` to `darwin/`** and top-level
7. **Delete `system/` directory**
8. **Parameterize `darwin-config.nix`** + update `hosts/saguaro.nix`
9. **Parameterize `devenv.nix`**
10. **Delete `interface.nix`, `patches.nix.bak`**
11. **Run `nix flake check`** to verify
12. **Build: `nix build .#darwinConfigurations.saguaro.system`**
