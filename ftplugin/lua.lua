if vim.b.did_lua_ftplugin then
  return
end
vim.b.did_lua_ftplugin = true

local opt_local = vim.opt_local
local set = vim.keymap.set

opt_local.expandtab = true
opt_local.formatprg =
  "stylua --call-parentheses=none --column-width=80 --indent-type=spaces --indent-width=2 -- -"
opt_local.shiftwidth = 2
opt_local.softtabstop = 2
opt_local.tabstop = 2

set(
  { "n", "v" },
  [[<leader><CR>]],
  [[:w !lua<CR>]],
  { buffer = true, desc = "Run current buffer" }
)
set(
  "n",
  [[<leader><Tab>]],
  [[<Cmd>up<CR>:new<CR>:terminal lua -i #<CR>]],
  { buffer = true, desc = "Load current buffer to lua" }
)
