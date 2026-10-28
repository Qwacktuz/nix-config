return {
  "epwalsh/obsidian.nvim",
  version = "*", -- Use latest release instead of latest commit
  lazy = true,
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
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
