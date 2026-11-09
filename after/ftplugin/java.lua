vim.opt_local.expandtab = true
vim.opt_local.makeprg = "javac"
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

vim.treesitter.start()

vim.keymap.set(
  "n",
  [[<leader>tf]],
  [[<Cmd>up | !palantir-java-format --palantir --replace %:S<CR>]],
  { buffer = true, desc = "Call `palantir-java-format` on current buffer" }
)
vim.keymap.set("n", [[<leader><CR>]], function()
  vim.cmd.update()
  vim.cmd.new()

  vim.cmd.terminal "java #:S"
  vim.cmd.startinsert()
end, { buffer = true, desc = "Run current buffer" })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. "|" or "")
  .. "setl et< mp< sw< sts< ts<"
  .. "|call v:lua.vim.treesitter.stop()"
  .. "|sil! nunmap <buffer> <leader>tf|sil! nunmap <buffer> <leader><CR>"
