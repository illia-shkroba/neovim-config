if vim.b.did_tf_ftplugin then
  return
end
vim.b.did_tf_ftplugin = true

vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2
