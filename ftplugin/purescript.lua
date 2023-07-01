if vim.b.did_purescript_ftplugin then
  return
end
vim.b.did_purescript_ftplugin = true

local api = vim.api
local fn = vim.fn
local fs = vim.fs
local loop = vim.loop
local opt_local = vim.opt_local
local set = vim.keymap.set

opt_local.expandtab = true
opt_local.makeprg = "spago build"
opt_local.shiftwidth = 2
opt_local.softtabstop = 2
opt_local.tabstop = 2

opt_local.errorformat = "%-G,"
  .. "%-Z,"
  .. "%W%f:%l:%c: Warning: %m,"
  .. "%E%f:%l:%c: Error:,"
  .. "%E%>%f:%l:%c:,"
  .. "%W%>%f:%l:%c:,"

local stylish_config = fn.stdpath "config"
  .. "/etc/options/file-type-options/haskell/stylish-haskell.yaml"
opt_local.formatprg = "stylish-haskell --config " .. stylish_config

set(
  "n",
  [[<leader>g]],
  [[<Cmd>silent !fast-tags -R --qualified .<CR>]],
  { buffer = true }
)

function vim.b.lsp_start()
  vim.lsp.start {
    name = "purescript-lsp",
    cmd = { "purescript-language-server", "--stdio" },
    root_dir = fs.dirname(
      fs.find({ "spago.dhall", "packages.dhall", "package.json" }, {
        path = api.nvim_buf_get_name(0),
        upward = true,
        stop = loop.os_homedir(),
        type = "file",
      })[1]
    ),
  }
end
