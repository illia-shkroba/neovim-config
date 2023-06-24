local M = {}

local lsp = vim.lsp

M.is_enabled = false

function M.callback()
  if M.is_enabled then
    M.start()
  end
end

function M.enable()
  M.is_enabled = true
  M.start()
end

function M.start()
  local start = vim.b.lsp_start or function() end
  start()
end

function M.disable()
  M.is_enabled = false
  M.stop()
end

function M.stop()
  lsp.stop_client(lsp.get_active_clients())
end

return M
