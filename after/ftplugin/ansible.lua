if vim.b.did_ansible_ftplugin then
  return
end
vim.b.did_ansible_ftplugin = true

vim.treesitter.start()

vim.api.nvim_create_autocmd("BufReadPost", {
  buf = vim.api.nvim_get_current_buf(),
  callback = function()
    vim.treesitter.start()
  end,
})
