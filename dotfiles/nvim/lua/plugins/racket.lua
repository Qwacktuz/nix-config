return {
  -- Ensure the racket tree-sitter parser is installed for syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "racket" })
      end
    end,
  },

  -- Configure nvim-lspconfig for racket-langserver
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        racket_langserver = {
          -- Pass the module launch flags directly to racket
          cmd = { "racket", "-l", "racket-langserver" },
          filetypes = { "racket", "scheme" },
        },
      },
    },
  },
}
