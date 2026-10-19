# Local writing checks in LazyVim

Restart Neovim after updating the out-of-store dotfiles. No new Neovim plugin
is required: LazyVim uses the Nix-installed `ltex-ls-plus`, with Mason disabled
for that server. It attaches to Markdown, LaTeX, Typst, plain text,
reStructuredText, and Git commit messages.

`modules/profiles/creative.nix` installs the server, including its bundled
LanguageTool engine, on hosts selecting `creative` or `full`. No separate
LanguageTool server or fastText CLI is needed.

| Command | Current buffer |
| --- | --- |
| `:WritingLanguage en` | English grammar, English/Bokmål spelling (default) |
| `:WritingLanguage nb` | Bokmål spelling, with LTeX's English diagnostics hidden |

The mode belongs to the current buffer and resets to English when a new buffer
is opened. It does not change unrelated LSP diagnostics or other buffers.
English grammar checking is local and updates as you edit. Neovim handles
spelling to avoid duplicate LTeX spelling warnings.

The configuration lives in `dotfiles/nvim/lua/plugins/writing.lua`.
Spelling is enabled when a prose filetype is set. Subsequent buffer switches,
LSP attachments, and language changes preserve manual spelling/diagnostic
toggles. Norwegian mode filters LTeX diagnostics before display; toggling all
diagnostics cannot expose English warnings there. Switching back to English
restores the latest grammar result without changing diagnostic visibility.

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

Validation: actual headless LazyVim sessions attached LTeX+, diagnosed
“This are a test.”, accepted valid Norwegian words, flagged Norwegian/English
typos, and switched diagnostic visibility without affecting other namespaces.
The freshly fetched pinned Norwegian dictionary and suggestions were checked
separately. Luna's Nix system derivation and Lua formatting checks passed.

Run the integration regression check with the installed LazyVim plugins,
`ltex-ls-plus`, and Norwegian dictionaries:

```sh
NVIM_LOG_FILE=/tmp/neovim-writing.log nvim --headless -c 'luafile checks/neovim-writing.lua'
```

It checks English/Typst grammar and correction actions, bilingual spelling, Norwegian filtering after
edits, global/buffer diagnostic toggles, spelling toggles, and buffer isolation.
