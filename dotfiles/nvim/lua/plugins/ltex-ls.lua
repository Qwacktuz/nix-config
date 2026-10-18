return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      require("config.writing").setup()
    end,
    opts = {
      servers = {
        ltex_plus = {
          enabled = vim.fn.executable("ltex-ls-plus") == 1,
          mason = false,
          cmd = { "ltex-ls-plus" },
          filetypes = require("config.writing").filetypes,
          flags = { debounce_text_changes = 500 },
          settings = {
            ltex = {
              enabled = true,
              language = "en-US",
              languageToolHttpServerUri = "",
              disabledRules = { ["en-US"] = { "MORFOLOGIK_RULE_EN_US" } },
            },
          },
        },
      },
    },
  },
}
