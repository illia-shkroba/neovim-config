if vim.b.did_cs_ftplugin then
  return
end
vim.b.did_cs_ftplugin = true

local opt_local = vim.opt_local
local set = vim.keymap.set

opt_local.expandtab = true
opt_local.shiftwidth = 4
opt_local.softtabstop = 4
opt_local.tabstop = 4

set("", [[gh]], [[<Cmd>OmniSharpCodeFormat | OmniSharpFixUsings<CR>]], { buffer = true })
