if vim.b.did_dot_ftplugin then
  return
end
vim.b.did_dot_ftplugin = true

vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

vim.treesitter.start()

vim.api.nvim_create_autocmd("BufReadPost", {
  buf = vim.api.nvim_get_current_buf(),
  callback = function()
    vim.treesitter.start()
  end,
})
