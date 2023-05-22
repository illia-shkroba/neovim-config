if vim.b.did_sh_ftplugin then
  return
end
vim.b.did_sh_ftplugin = true

local opt_local = vim.opt_local
local set = vim.keymap.set

opt_local.expandtab = true
opt_local.makeprg = "shellcheck"
opt_local.shiftwidth = 2
opt_local.softtabstop = 2
opt_local.tabstop = 2

opt_local.formatprg = "shfmt -s -i "
  .. opt_local.tabstop._value
  .. " -bn -ci -sr"

set("", [[<leader><CR>]], [[<Cmd>w !bash<CR>]], { buffer = true })
set("n", [[<leader><Tab>]], [[<Cmd>up<CR>:new<CR>:terminal bash --init-file #<CR>]], { buffer = true })
