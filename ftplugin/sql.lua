if vim.b.did_sql_ftplugin then
  return
end
vim.b.did_sql_ftplugin = true

local opt_local = vim.opt_local

opt_local.expandtab = true
opt_local.makeprg = "pg_format"
opt_local.shiftwidth = 4
opt_local.softtabstop = 4
opt_local.tabstop = 4
