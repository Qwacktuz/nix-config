return {
  -- This is an override for mason.nvim which is preinstalled with LazyVim (can be put with other mason.nvim entries)
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "tinymist",
      },
    },
  },
}
