if vim.b.did_java_ftplugin then
  return
end
vim.b.did_java_ftplugin = true

vim.opt_local.expandtab = true
vim.opt_local.makeprg = "javac"
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

vim.treesitter.start()

vim.api.nvim_create_autocmd("BufReadPost", {
  buf = vim.api.nvim_get_current_buf(),
  callback = function()
    vim.treesitter.start()
  end,
})

vim.keymap.set("n", [[<leader><CR>]], function()
  vim.cmd.update()
  vim.cmd.new()

  vim.cmd.terminal "java '#'"
  vim.cmd.startinsert()
end, { buffer = true, desc = "Run current buffer" })
