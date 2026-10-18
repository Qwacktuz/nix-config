local filetypes = { "markdown", "tex", "plaintex", "typst", "text", "gitcommit", "rst" }
local grammar = {}

local function publish(err, result, ctx)
  if err or not result then
    return
  end
  local buf = vim.uri_to_bufnr(result.uri)
  -- Retain English results without changing Neovim's diagnostic toggle state.
  grammar[buf] = { result = result, ctx = ctx }
  if vim.b[buf].writing_language == "nb" then
    result = vim.tbl_extend("force", result, { diagnostics = {} })
  end
  vim.lsp.diagnostic.on_publish_diagnostics(nil, result, ctx)
end

local function apply_language(buf)
  local norwegian = vim.b[buf].writing_language == "nb"
  vim.bo[buf].spelllang = norwegian and "nb" or "en_us,nb"
  vim.bo[buf].spellfile = vim.fn.stdpath("data") .. "/site/spell/" .. (norwegian and "nb.utf-8.add" or "en.utf-8.add")
  local latest = grammar[buf]
  if latest and vim.lsp.buf_is_attached(buf, latest.ctx.client_id) then
    publish(nil, latest.result, latest.ctx)
  end
end

return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.fn.mkdir(vim.fn.stdpath("data") .. "/site/spell", "p")
      local group = vim.api.nvim_create_augroup("writing_languages", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = filetypes,
        callback = function(event)
          apply_language(event.buf)
          for _, win in ipairs(vim.fn.win_findbuf(event.buf)) do
            vim.wo[win].spell = true
          end
        end,
      })
      vim.api.nvim_create_autocmd("BufWipeout", {
        group = group,
        callback = function(event)
          grammar[event.buf] = nil
        end,
      })
      vim.api.nvim_create_autocmd("LspDetach", {
        group = group,
        callback = function(event)
          local latest = grammar[event.buf]
          if latest and latest.ctx.client_id == event.data.client_id then
            grammar[event.buf] = nil
          end
        end,
      })
      vim.api.nvim_create_user_command("WritingLanguage", function(args)
        if args.args ~= "en" and args.args ~= "nb" then
          vim.notify("Use :WritingLanguage en or :WritingLanguage nb", vim.log.levels.ERROR)
          return
        end
        if not vim.tbl_contains(filetypes, vim.bo.filetype) then
          vim.notify("WritingLanguage requires a prose buffer", vim.log.levels.ERROR)
          return
        end
        vim.b.writing_language = args.args
        apply_language(vim.api.nvim_get_current_buf())
      end, {
        nargs = 1,
        complete = function()
          return { "en", "nb" }
        end,
        desc = "Local English grammar/bilingual spelling, or Norwegian spelling only",
      })
    end,
    opts = {
      servers = {
        ltex_plus = {
          enabled = vim.fn.executable("ltex-ls-plus") == 1,
          mason = false,
          cmd = { "ltex-ls-plus" },
          filetypes = filetypes,
          flags = { debounce_text_changes = 500 },
          handlers = { ["textDocument/publishDiagnostics"] = publish },
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
