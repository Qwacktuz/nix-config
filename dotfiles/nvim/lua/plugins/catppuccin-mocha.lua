return {
  -- add gruvbox
  -- { "ellisonleao/gruvbox.nvim" },
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
  {
    "catppuccin/nvim",
    -- Pin version to prevent https://github.com/LazyVim/LazyVim/issues/6355
    -- tag = "v1.10.0",
    opts = {
      transparent_background = true,
      float = {
        -- enable transparent windows
        transparent = true,
      },
    },
  },
}
