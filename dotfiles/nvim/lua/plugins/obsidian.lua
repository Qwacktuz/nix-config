return {
  "epwalsh/obsidian.nvim",
  version = "*", -- Use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  dependencies = {
    -- Required
    "nvim-lua/plenary.nvim",

    -- Optional dependencies 👇
  },
  opts = function()
    local config_home = vim.env.XDG_CONFIG_HOME or vim.fn.expand("~/.config")
    local path = config_home .. "/sops-nix/secrets/obsidian_workspaces"
    if vim.fn.filereadable(path) == 0 then
      vim.notify("Obsidian workspaces unavailable: start sops-nix", vim.log.levels.WARN)
      return { workspaces = {} }
    end
    return { workspaces = vim.json.decode(table.concat(vim.fn.readfile(path), "\n")) }
  end,
}
