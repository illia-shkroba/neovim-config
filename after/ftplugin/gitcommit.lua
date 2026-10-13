if vim.b.did_gitcommit_ftplugin then
  return
end
vim.b.did_gitcommit_ftplugin = true

vim.opt_local.textwidth = 0
