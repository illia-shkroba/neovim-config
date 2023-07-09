if vim.b.did_purescript_ftplugin then
  return
end
vim.b.did_purescript_ftplugin = true

local fn = vim.fn
local opt_local = vim.opt_local
local set = vim.keymap.set

opt_local.expandtab = true
opt_local.makeprg = "spago build"
opt_local.shiftwidth = 2
opt_local.softtabstop = 2
opt_local.tabstop = 2

opt_local.errorformat = "%-G,"
  .. "%-Z,"
  .. "%W%f:%l:%c: Warning: %m,"
  .. "%E%f:%l:%c: Error:,"
  .. "%E%>%f:%l:%c:,"
  .. "%W%>%f:%l:%c:,"

local stylish_config = fn.stdpath "config"
  .. "/etc/options/file-type-options/haskell/stylish-haskell.yaml"
opt_local.formatprg = "stylish-haskell --config " .. stylish_config

set(
  "n",
  [[<leader>g]],
  [[<Cmd>silent !fast-tags -R --qualified .<CR>]],
  { buffer = true }
)
