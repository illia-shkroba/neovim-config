vim.g.lsp_enabled = false

function start_lsp()
  local lsp_start = vim.b.lsp_start or function() end
  lsp_start()
end

function stop_lsp()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
end

function enable_lsp()
  vim.g.lsp_enabled = true
  vim.opt.omnifunc = "v:lua.vim.lsp.omnifunc"
  start_lsp()
end

function disable_lsp()
  vim.g.lsp_enabled = false
  vim.opt.omnifunc = "syntaxcomplete#Complete"
  stop_lsp()
end

function lsp_callback()
  if vim.g.lsp_enabled then
    start_lsp()
  end
end
