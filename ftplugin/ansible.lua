if vim.b.did_ansible_ftplugin then
  return
end
vim.b.did_ansible_ftplugin = true

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "<filetype>" },
  callback = function()
    vim.treesitter.start()
  end,
})
