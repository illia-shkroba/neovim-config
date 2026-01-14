if vim.b.did_sql_ftplugin then
  return
end
vim.b.did_sql_ftplugin = true

vim.opt_local.expandtab = true
vim.opt_local.makeprg = "pg_format"
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "<filetype>" },
  callback = function()
    vim.treesitter.start()
  end,
})
