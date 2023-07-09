if vim.b.did_dockerfile_ftplugin then
  return
end
vim.b.did_dockerfile_ftplugin = true

local opt_local = vim.opt_local

opt_local.expandtab = true
opt_local.makeprg = "hadolint"
opt_local.shiftwidth = 2
opt_local.softtabstop = 2
opt_local.tabstop = 2
