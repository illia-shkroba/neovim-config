if vim.b.did_nix_ftplugin then
  return
end
vim.b.did_nix_ftplugin = true

local opt_local = vim.opt_local
local set = vim.keymap.set

opt_local.expandtab = true
opt_local.formatprg = "nixfmt"
opt_local.shiftwidth = 2
opt_local.softtabstop = 2
opt_local.tabstop = 2

set("", [[<leader><CR>]], [[<Cmd>up | !nix-instantiate --eval --strict %<CR>]], { buffer = true })

function vim.b.lsp_start()
  vim.lsp.start {
    name = "nix-lsp",
    cmd = { "rnix-lsp" },
  }
end
