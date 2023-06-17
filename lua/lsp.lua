local M = {}

local b = vim.b
local lsp = vim.lsp
local opt = vim.opt

M.is_enabled = false

function M.callback()
  if M.is_enabled then
    M.start()
  end
end

function M.enable()
  M.is_enabled = true
  opt.omnifunc = "v:lua.vim.lsp.omnifunc"
  M.start()
end

function M.start()
  local start = b.lsp_start or function() end
  start()
end

function M.disable()
  M.is_enabled = false
  opt.omnifunc = "syntaxcomplete#Complete"
  M.stop()
end

function M.stop()
  lsp.stop_client(lsp.get_active_clients())
end

return M
