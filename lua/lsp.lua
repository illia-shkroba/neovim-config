local M = {}

M.is_lsp_enabled = false

function M.lsp_callback()
  if M.is_lsp_enabled then
    M.start_lsp()
  end
end

function M.enable_lsp()
  M.is_lsp_enabled = true
  vim.opt.omnifunc = "v:lua.vim.lsp.omnifunc"
  M.start_lsp()
end

function M.start_lsp()
  local lsp_start = vim.b.lsp_start or function() end
  lsp_start()
end

function M.disable_lsp()
  M.is_lsp_enabled = false
  vim.opt.omnifunc = "syntaxcomplete#Complete"
  M.stop_lsp()
end

function M.stop_lsp()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
end

return M
