if vim.b.did_nix_ftplugin then
  return
end
vim.b.did_nix_ftplugin = true

vim.opt_local.expandtab = true
vim.opt_local.formatprg = "nixfmt"
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

vim.keymap.set(
  "n",
  [[<leader><CR>]],
  [[<Cmd>up | !nix-instantiate --eval --strict %<CR>]],
  { buffer = true, desc = "Run current buffer" }
)
