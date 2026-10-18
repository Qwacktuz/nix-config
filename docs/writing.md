# Local writing checks in LazyVim

Restart Neovim after updating the out-of-store dotfiles. No new Neovim plugin
is required: LazyVim uses the Nix-installed `ltex-ls-plus`, with Mason disabled
for that server. It attaches to Markdown, LaTeX, Typst, plain text,
reStructuredText, and Git commit messages.

| Command | Current buffer |
| --- | --- |
| `:WritingLanguage en` | English grammar, English/Bokmål spelling (default) |
| `:WritingLanguage nb` | Bokmål spelling, with LTeX's English diagnostics hidden |

The mode belongs to the current buffer and resets to English when a new buffer
is opened. It does not change unrelated LSP diagnostics or other buffers.
English grammar checking is local and updates as you edit. Neovim handles
spelling to avoid duplicate LTeX spelling warnings.

- `]s` / `[s`: next/previous spelling issue.
- `z=`: spelling suggestions; `zg`: add a word to your personal dictionary.
- `<leader>ca`: LSP code actions for supported grammar corrections.
- `:checkhealth vim.lsp` / `:LspInfo`: inspect LTeX attachment.
- LazyVim's `<leader>us` can toggle spelling highlights.

Norwegian **Bokmål** is spelling-only in this setup. LTeX+ does not provide
offline Norwegian grammar; its Norwegian checker requires LanguageTool's
hosted API. The user chose local checks, so no HTTP endpoint or credentials
are configured and documents are not sent to that service.
[Upstream language support](https://ltex-plus.github.io/ltex-plus/supported-languages.html).

The English dictionary ships with Neovim. Home Manager pins the official Vim
Bokmål dictionary and suggestions under `nvim/site/spell` through the
Neovim dotfiles feature. A successful Darwin/Home Manager switch provisions them
on a fresh machine; the existing Saguaro dictionaries already work. Personal
`*.add` dictionaries remain writable and unmanaged.

Validation: an actual headless LazyVim session attached LTeX+, diagnosed
“This are a test.”, accepted valid Norwegian words, flagged Norwegian/English
typos, and switched diagnostic visibility without affecting other namespaces.
The freshly fetched pinned Norwegian dictionary and suggestions were checked
separately. Luna's Nix system derivation and Lua formatting checks passed.
