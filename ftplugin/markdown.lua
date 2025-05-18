if vim.b.did_markdown_ftplugin then
  return
end
vim.b.did_markdown_ftplugin = true

local opt_local = vim.opt_local

opt_local.formatprg = "mdformat --number -"
opt_local.spell = true
opt_local.textwidth = 100
