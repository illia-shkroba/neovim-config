if vim.b.did_markdown_ftplugin then
  return
end
vim.b.did_markdown_ftplugin = true

vim.opt_local.formatprg = "mdformat --number -"
vim.opt_local.spell = true
vim.opt_local.textwidth = 100
