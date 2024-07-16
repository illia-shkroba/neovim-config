if vim.b.did_haskell_ftplugin then
  return
end
vim.b.did_haskell_ftplugin = true

local fn = vim.fn
local opt_local = vim.opt_local
local set = vim.keymap.set

opt_local.equalprg = "hindent"
opt_local.expandtab = true
opt_local.makeprg = "stack build --cabal-verbosity 0"
opt_local.shiftwidth = 2
opt_local.softtabstop = 2
opt_local.tabstop = 2

opt_local.errorformat = "%-G,"
  .. "%-Z,"
  .. "%W%\\S%#> %f:%l:%c: Warning: %m,"
  .. "%E%\\S%#> %f:%l:%c: Error:,"
  .. "%W%f:%l:%c: Warning: %m,"
  .. "%E%f:%l:%c: Error:,"
  .. "%E%>%f:%l:%c:,"
  .. "%W%>%f:%l:%c:,"

local stylish_config = fn.stdpath "config"
  .. "/etc/options/file-type-options/haskell/stylish-haskell.yaml"
opt_local.formatprg = "stylish-haskell --config " .. stylish_config

set("", [[<leader><CR>]], [[<Cmd>w !stack ghci<CR>]], { buffer = true })
set(
  "n",
  [[<leader><Tab>]],
  [[<Cmd>up<CR>:new<CR>:terminal stack ghci #<CR>]],
  { buffer = true }
)
set("n", [[<leader>gt]], [[:!fast-tags -R --qualified .]], { buffer = true })
