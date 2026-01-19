if vim.b.did_purescript_ftplugin then
  return
end
vim.b.did_purescript_ftplugin = true

vim.opt_local.expandtab = true
vim.opt_local.makeprg = "spago build"
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

vim.opt_local.errorformat = "%-G,"
  .. "%-Z,"
  .. "%W%f:%l:%c: Warning: %m,"
  .. "%E%f:%l:%c: Error:,"
  .. "%E%>%f:%l:%c:,"
  .. "%W%>%f:%l:%c:,"

vim.opt_local.formatprg = "purs-tidy format --import-sort-ide --import-wrap-auto --indent "
  .. vim.opt_local.tabstop._value
  .. " --width 80"

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "<filetype>" },
  callback = function()
    vim.treesitter.start()
  end,
})

vim.keymap.set(
  "n",
  [[<leader>tg]],
  [[:!fast-tags -R --qualified .]],
  { buffer = true, desc = "Generate tags" }
)
