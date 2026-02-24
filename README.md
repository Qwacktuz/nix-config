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

## TODO

- Streamline devshell creation
- languagetool server for neovim (ltex-ls-plus vs ltex-ls?) and activate
  norwegian spellchecking
  - <https://dev.languagetool.org/http-server>
  - <https://nix.dev/tutorials/packaging-existing-software> (nix package?)
  - <https://forum.languagetool.org/t/norwegian-language/11752>

## Various resources

**Docs/cheatsheets:**

- <https://jdheyburn.co.uk/blog/nix-cheat-sheet>

**Flake parts and dendritic design:**

- <https://flake.parts>
- <https://github.com/Doc-Steve/dendritic-design-with-flake-parts>
- <https://dendrix.oeiuwq.com>
- <https://github.com/vic/flake-file>
