if vim.b.did_perl_ftplugin then
  return
end
vim.b.did_perl_ftplugin = true

local opt_local = vim.opt_local
local set = vim.keymap.set

opt_local.expandtab = true
opt_local.formatprg = "LC_ALL='C' perltidy"
opt_local.shiftwidth = 4
opt_local.softtabstop = 4
opt_local.tabstop = 4

set(
  "",
  [[<leader><CR>]],
  [[<Cmd>w !perl<CR>]],
  { buffer = true, desc = "Run current buffer" }
)
