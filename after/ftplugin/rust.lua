if vim.b.did_rust_ftplugin then
  return
end
vim.b.did_rust_ftplugin = true

vim.opt_local.colorcolumn = "100"
vim.opt_local.expandtab = true
vim.opt_local.formatprg = "rustfmt"
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4
vim.opt_local.makeprg = "cargo build"

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "<filetype>" },
  callback = function()
    vim.treesitter.start()
  end,
})

vim.keymap.set("n", [[<leader><CR>]], function()
  vim.cmd.update()
  vim.cmd.new()

  vim.cmd.terminal "cargo run --quiet"
  vim.cmd.startinsert()
end, { buffer = true, desc = "Run current buffer" })
