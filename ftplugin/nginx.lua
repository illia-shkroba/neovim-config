if vim.b.did_nginx_ftplugin then
  return
end
vim.b.did_nginx_ftplugin = true

vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4
