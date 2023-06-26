local M = {}

local api = vim.api
local lsp = vim.lsp

M.is_enabled = false

function M.start_callback(event)
  if M.is_enabled then
    M.start(event.buf)
  end
end

function M.enable()
  M.is_enabled = true
  M.start(api.nvim_buf_get_number(0))
end

function M.start(buffer_number)
  if vim.b[buffer_number].is_lsp_configured then
    return
  end

  local start = vim.b[buffer_number].lsp_start or function() end
  start()

  vim.b[buffer_number].is_lsp_configured = true
end

function M.stop_callback(event)
  vim.b[event.buf].is_lsp_configured = false
end

function M.disable()
  M.is_enabled = false
  M.stop_all()
end

function M.stop_all()
  lsp.stop_client(lsp.get_active_clients())
end

return M
