if vim.b.did_rust_ftplugin then
  return
end
vim.b.did_rust_ftplugin = true

local cmd = vim.cmd
local opt_local = vim.opt_local
local set = vim.keymap.set

opt_local.colorcolumn = "100"
opt_local.expandtab = true
opt_local.formatprg = "rustfmt"
opt_local.shiftwidth = 4
opt_local.softtabstop = 4
opt_local.tabstop = 4
opt_local.makeprg = "cargo build"

set("n", [[<leader><CR>]], function()
  cmd.update()
  cmd.new()

  cmd.terminal "cargo run --quiet"
  cmd.startinsert()
end, { buffer = true, desc = "Run current buffer" })
