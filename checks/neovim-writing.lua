-- NVIM_LOG_FILE=/tmp/neovim-writing.log nvim --headless -c 'luafile checks/neovim-writing.lua'
local ok, err = xpcall(function()
  vim.cmd.edit(vim.fn.tempname() .. ".md")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "This are a test." })
  vim.bo.filetype = "markdown"
  local buf = vim.api.nvim_get_current_buf()
  assert(
    vim.wait(45000, function()
      return #vim.lsp.get_clients({ bufnr = buf, name = "ltex_plus" }) > 0 and #vim.diagnostic.get(buf) > 0
    end, 100),
    "LTeX did not attach and diagnose English grammar"
  )
  local client = vim.lsp.get_clients({ bufnr = buf, name = "ltex_plus" })[1]
  local ns = vim.lsp.diagnostic.get_namespace(client.id, false)
  assert(#vim.diagnostic.get(buf, { namespace = ns }) > 0)
  assert(client.config.cmd[1] == "ltex-ls-plus")
  assert(client.config.settings.ltex.languageToolHttpServerUri == "")
  local diagnostic = vim.diagnostic.get(buf, { namespace = ns })[1].user_data.lsp
  local actions = client:request_sync("textDocument/codeAction", {
    textDocument = { uri = vim.uri_from_bufnr(buf) },
    range = diagnostic.range,
    context = { diagnostics = { diagnostic } },
  }, 10000, buf)
  assert(actions and not actions.err and vim.iter(actions.result or {}):any(function(action)
    return action.edit ~= nil
  end), "LTeX did not offer a grammar correction")
  assert(vim.bo.spelllang == "en_us,nb" and vim.wo.spell)
  assert(vim.fn.spellbadword("university")[1] == "")
  assert(vim.fn.spellbadword("universitetet")[1] == "")
  assert(vim.fn.spellbadword("recieve")[1] ~= "")

  local other = vim.api.nvim_create_namespace("writing-test-other")
  vim.diagnostic.set(other, buf, { { lnum = 0, col = 0, message = "Other checker" } })
  vim.cmd("WritingLanguage nb")
  assert(vim.bo.spelllang == "nb")
  assert(#vim.diagnostic.get(buf, { namespace = ns }) == 0)
  assert(#vim.diagnostic.get(buf, { namespace = other }) == 1)
  assert(vim.fn.spellbadword("universitetet")[1] == "")
  assert(vim.fn.spellbadword("universitette")[1] ~= "")

  local published = 0
  local publish = client.handlers["textDocument/publishDiagnostics"]
  client.handlers["textDocument/publishDiagnostics"] = function(...)
    publish(...)
    published = published + 1
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "These is another test." })
  assert(
    vim.wait(30000, function()
      return published > 0
    end, 100),
    "LTeX did not publish after editing in Norwegian mode"
  )
  assert(#vim.diagnostic.get(buf, { namespace = ns }) == 0)
  vim.diagnostic.enable(false)
  vim.diagnostic.enable(true)
  assert(#vim.diagnostic.get(buf, { namespace = ns }) == 0, "Global toggle exposed English diagnostics in nb mode")

  vim.wo.spell = false
  vim.diagnostic.enable(false, { bufnr = buf })
  vim.cmd("WritingLanguage en")
  assert(not vim.wo.spell, "Language command reset the spell toggle")
  assert(not vim.diagnostic.is_enabled({ bufnr = buf, ns_id = ns }))
  assert(#vim.diagnostic.get(buf, { namespace = ns }) > 0, "English grammar was not restored")
  print("PASS: local English grammar, bilingual spelling, Norwegian filtering, independent toggles")

  vim.cmd.edit(vim.fn.tempname() .. ".typ")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, { "This are a test." })
  vim.bo.filetype = "typst"
  local typst = vim.api.nvim_get_current_buf()
  assert(vim.bo.spelllang == "en_us,nb" and vim.wo.spell)
  assert(
    vim.wait(30000, function()
      local clients = vim.lsp.get_clients({ bufnr = typst, name = "ltex_plus" })
      return clients[1]
        and #vim.diagnostic.get(typst, {
            namespace = vim.lsp.diagnostic.get_namespace(clients[1].id, false),
          })
          > 0
    end, 100),
    "LTeX did not diagnose Typst grammar"
  )
  vim.cmd("WritingLanguage nb")
  assert(vim.bo[buf].spelllang == "en_us,nb", "Language mode leaked across buffers")
  assert(#vim.diagnostic.get(buf, { namespace = ns }) > 0)
  vim.cmd.buffer(buf)
  assert(not vim.wo.spell, "Buffer switch reset the spell toggle")
  assert(not vim.diagnostic.is_enabled({ bufnr = buf, ns_id = ns }), "Buffer switch reset the diagnostic toggle")
  print("PASS: Typst grammar, buffer-local language selection, and toggle persistence across buffer switches")
end, debug.traceback)
if not ok then
  io.stderr:write(err .. "\n")
  vim.cmd("cquit 1")
else
  vim.cmd("qa!")
end
