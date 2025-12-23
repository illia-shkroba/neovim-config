if vim.b.did_sh_ftplugin then
  return
end
vim.b.did_sh_ftplugin = true

local operator = require "operator"

vim.opt_local.expandtab = true
vim.opt_local.makeprg = "shellcheck"
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

vim.opt_local.formatprg = "shfmt -s -i "
  .. vim.opt_local.tabstop._value
  .. " -bn -ci -sr"

vim.keymap.set(
  { "n" },
  [[<CR>]],
  [[<Cmd>.w !bash<CR>]],
  { buffer = true, desc = "Run current line" }
)
vim.keymap.set({ "n" }, [[<leader><CR>]], function()
  vim.api.nvim_put({ vim.api.nvim_get_current_line() }, "l", true, false)
  vim.cmd ".!bash"
end, { buffer = true, desc = "Paste current line's output below" })
vim.keymap.set(
  "n",
  [[<leader><Tab>]],
  [[<Cmd>up<CR>:new<CR>:terminal bash --init-file #<CR>]],
  { buffer = true, desc = "Load current buffer to bash" }
)
vim.keymap.set(
  { "v" },
  [[<CR>]],
  [[:w !bash<CR>]],
  { buffer = true, desc = "Run selected lines" }
)
vim.keymap.set(
  { "v" },
  [[<leader><CR>]],
  operator.expr {
    function_ = function(region)
      vim.cmd "'>"
      vim.api.nvim_put(region.lines, "l", true, false)
      vim.cmd "'[,']!bash"
    end,
    readonly = true,
  },
  { expr = true, buffer = true, desc = "Paste selected lines' output below" }
)
