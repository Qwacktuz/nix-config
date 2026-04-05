# Nix configuration flake

- Featuring a dendritic pattern approach
- Docs coming soon™️

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

- set up <https://github.com/oddlama/nix-topology>
- Further modularize packages into packages built with perSystem (flake parts) so I can build for each system using DRY (limit identical configuration in separate independent darwinModules or nixosModules)
  - May use <https://birdeehub.github.io/nix-wrapper-modules/md/getting-started.html>
  - Look into how to build my own derivations (everything cross platform should exist in a perSystem package derivation)
- Consider migrating from HCL to terranix (compiles to \*.tf.json)
  - <https://terranix.org/getting-started.html>
- Streamline devshell creation
- Consider moving back to pure direnv (not sure if I need devenv capabilities really) - make sure to disable warnings and logging (env var?)
- languagetool server for neovim (ltex-ls-plus vs ltex-ls?) and activate
  norwegian spellchecking
  - <https://dev.languagetool.org/http-server>
  - <https://nix.dev/tutorials/packaging-existing-software> (nix package?)
  - <https://forum.languagetool.org/t/norwegian-language/11752>

## Various resources

**Docs/cheatsheets:**

- <https://jdheyburn.co.uk/blog/nix-cheat-sheet>

- [Automatic lock flattening](https://github.com/fzakaria/nix-auto-follow)

**Flake parts and dendritic design:**

- <https://flake.parts>
- <https://github.com/Doc-Steve/dendritic-design-with-flake-parts>
- <https://dendrix.oeiuwq.com>
- <https://github.com/vic/flake-file>
