if vim.b.did_dhall_ftplugin then
  return
end
vim.b.did_dhall_ftplugin = true

local opt_local = vim.opt_local
local set = vim.keymap.set

opt_local.equalprg = "dhall lint"
opt_local.expandtab = true
opt_local.formatprg = "dhall format"
opt_local.shiftwidth = 4
opt_local.softtabstop = 4
opt_local.tabstop = 4

set(
  "",
  [[<leader><CR>]],
  [[<Cmd>w !dhall-to-json<CR>]],
  { buffer = true, desc = "Run current buffer" }
)
set(
  "n",
  [[<leader><Tab>]],
  [[<Cmd>up<CR>:new<CR>:terminal dhall-to-json --file #<CR>]],
  { buffer = true, desc = "Load current buffer to dhall-to-json" }
)
