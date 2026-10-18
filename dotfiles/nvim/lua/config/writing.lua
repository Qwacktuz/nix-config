local M = {}

M.filetypes = { "markdown", "tex", "plaintex", "typst", "text", "gitcommit", "rst" }

local function apply(buf)
  local norwegian = vim.b[buf].writing_language == "nb"
  vim.bo[buf].spelllang = norwegian and "nb" or "en_us,nb"
  vim.bo[buf].spellfile = vim.fn.stdpath("data") .. "/site/spell/" .. (norwegian and "nb.utf-8.add" or "en.utf-8.add")
  for _, win in ipairs(vim.fn.win_findbuf(buf)) do
    vim.wo[win].spell = true
  end
  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf, name = "ltex_plus" })) do
    for _, pull in ipairs({ false, true }) do
      vim.diagnostic.enable(not norwegian, {
        bufnr = buf,
        ns_id = vim.lsp.diagnostic.get_namespace(client.id, pull),
      })
    end
  end
end

function M.setup()
  vim.fn.mkdir(vim.fn.stdpath("data") .. "/site/spell", "p")
  local group = vim.api.nvim_create_augroup("writing_languages", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = M.filetypes,
    callback = function(event)
      apply(event.buf)
    end,
  })
  vim.api.nvim_create_autocmd({ "LspAttach", "BufWinEnter" }, {
    group = group,
    callback = function(event)
      if vim.tbl_contains(M.filetypes, vim.bo[event.buf].filetype) then
        apply(event.buf)
      end
    end,
  })
  vim.api.nvim_create_user_command("WritingLanguage", function(args)
    if args.args ~= "en" and args.args ~= "nb" then
      vim.notify("Use :WritingLanguage en or :WritingLanguage nb", vim.log.levels.ERROR)
      return
    end
    vim.b.writing_language = args.args
    apply(vim.api.nvim_get_current_buf())
  end, {
    nargs = 1,
    complete = function()
      return { "en", "nb" }
    end,
    desc = "Local English grammar/bilingual spelling, or Norwegian spelling only",
  })
end

return M
