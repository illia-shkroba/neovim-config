if vim.b.did_tf_ftplugin then
  return
end
vim.b.did_tf_ftplugin = true

local opt_local = vim.opt_local

opt_local.expandtab = true
opt_local.shiftwidth = 2
opt_local.softtabstop = 2
opt_local.tabstop = 2

function vim.b.lsp_start()
  vim.lsp.start {
    name = "terraform-lsp",
    cmd = { "terraform-ls", "serve" },
  }
end
