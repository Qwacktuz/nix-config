# Neovim configuration

LazyVim is bootstrapped by `init.lua` and `lua/config/lazy.lua`. Home Manager
installs Neovim and links this directory from `~/nix-config/dotfiles/nvim`.
`lazy-lock.json` is intentionally ignored, so plugin revisions are local.

## Configuration

- `lua/config/lazy.lua`: LazyVim language/editor extras and plugin loading.
- `lua/config/options.lua`: disables relative line numbers.
- `lua/plugins/`: Catppuccin Mocha, Blink's super-tab completion preset, Mason
  tools, Obsidian, Racket, Typst preview, and local writing checks.
- `lazyvim.json`: LazyVim-managed extra selections and upgrade state.

There are no custom keymap or autocmd override files. Default keybindings come
from the installed LazyVim version; use `<leader>sk` to inspect mappings or
`:map` to inspect Neovim's active mappings.

Mason remains enabled for LazyVim-managed tools; `plugins/mason.lua` additionally
requests `tinymist` and `tofu-ls`. LTeX+ is the exception: it uses the Nix-installed
`ltex-ls-plus` with Mason disabled. It activates only when the executable is on
PATH; select the creative/full profile for it. Project language runtimes belong
in the named Nix development shells. Racket additionally needs
`racket-langserver` available to the selected Racket runtime.

Obsidian workspace paths are read at runtime from the SOPS secret
`~/.config/sops-nix/secrets/obsidian_workspaces`. Missing secrets produce a warning
and an empty workspace list; plaintext vault paths do not belong in this file.

See [the writing guide](../../docs/writing.md) for English grammar, bilingual
spelling, `:WritingLanguage en|nb`, and the integration regression check.
