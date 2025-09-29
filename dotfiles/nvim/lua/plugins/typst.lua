return {
  -- This is an override for mason.nvim which is preinstalled with LazyVim (can be put with other mason.nvim entries)
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "tinymist" },
    },
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tinymist = {
          settings = {
            formatterMode = "typstyle", -- or "typstfmt"
            exportPdf = "onType", -- "never", "onType", "onSave"
            semanticTokens = "disable",
          },
        },
      },
    },
  },

  {
    "chomosuke/typst-preview.nvim",
    ft = "typst", -- load only for Typst files
    version = "1.*", -- match docs
    opts = {}, -- calls setup() with defaults
  },
}
