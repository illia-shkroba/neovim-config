if vim.b.did_markdown_ftplugin then
  return
end
vim.b.did_markdown_ftplugin = true

vim.opt_local.formatprg = "mdformat --number -"
vim.opt_local.spell = true
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "<filetype>" },
  callback = function()
    vim.treesitter.start()
  end,
})
