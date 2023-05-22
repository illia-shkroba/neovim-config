if vim.b.did_json_ftplugin then
  return
end
vim.b.did_json_ftplugin = true

local opt_local = vim.opt_local

opt_local.expandtab = true
opt_local.formatprg = "jq"
opt_local.shiftwidth = 2
opt_local.softtabstop = 2
opt_local.tabstop = 2
