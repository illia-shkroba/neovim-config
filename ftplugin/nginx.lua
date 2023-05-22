if vim.b.did_nginx_ftplugin then
  return
end
vim.b.did_nginx_ftplugin = true

local opt_local = vim.opt_local

opt_local.expandtab = true
opt_local.shiftwidth = 4
opt_local.softtabstop = 4
opt_local.tabstop = 4
