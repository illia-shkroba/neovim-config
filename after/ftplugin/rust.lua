vim.opt_local.colorcolumn = "100"
vim.opt_local.expandtab = true
vim.opt_local.formatprg = "rustfmt"
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4
vim.opt_local.makeprg = "cargo build"

vim.treesitter.start()

vim.keymap.set("n", [[<leader><CR>]], function()
  vim.cmd.update()
  vim.cmd.new()

  vim.cmd.terminal "cargo run --quiet"
  vim.cmd.startinsert()
end, { buffer = true, desc = "Run current buffer" })

vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. "|" or "")
  .. "setl cc< et< fp< sw< sts< ts< mp<"
  .. "|call v:lua.vim.treesitter.stop()"
  .. "|sil! nunmap <buffer> <leader><CR>"
