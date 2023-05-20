local is_lsp_enabled = false

local function start_lsp()
  local lsp_start = vim.b.lsp_start or function() end
  lsp_start()
end

local function enable_lsp()
  is_lsp_enabled = true
  vim.opt.omnifunc = "v:lua.vim.lsp.omnifunc"
  start_lsp()
end

local function stop_lsp()
  vim.lsp.stop_client(vim.lsp.get_active_clients())
end

local function disable_lsp()
  is_lsp_enabled = false
  vim.opt.omnifunc = "syntaxcomplete#Complete"
  stop_lsp()
end

local function lsp_callback()
  if is_lsp_enabled then
    start_lsp()
  end
end

return {
  disable_lsp = disable_lsp,
  enable_lsp = enable_lsp,
  is_lsp_enabled = function()
    return is_lsp_enabled
  end,
  lsp_callback = lsp_callback,
  start_lsp = start_lsp,
  stop_lsp = stop_lsp,
}
