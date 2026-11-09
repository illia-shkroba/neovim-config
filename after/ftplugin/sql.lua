local sqlfluff_config = vim.fn.shellescape(
  vim.fs.joinpath(
    vim.fn.stdpath "config",
    "etc",
    "options",
    "filetype-options",
    "sql",
    ".sqlfluff"
  )
)

vim.opt_local.errorformat = [[::%trror title=SQLFluff\,file=%f\,line=%l\,col=%c\,%*[^:]::%m,]]
  .. [[::%tarning title=SQLFluff\,file=%f\,line=%l\,col=%c\,%*[^:]::%m,]]
  .. [[%-G%.%#]]
vim.opt_local.expandtab = true
vim.opt_local.formatprg = "sqlfluff fix --config "
  .. sqlfluff_config
  .. " --stdin-filename %:S - 2>/dev/null"
vim.opt_local.makeprg = "sqlfluff lint --config "
  .. sqlfluff_config
  .. " --format github-annotation-native"
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

vim.treesitter.start()

vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. "|" or "")
  .. "setl efm< et< fp< mp< sw< sts< ts<"
  .. "|call v:lua.vim.treesitter.stop()"
