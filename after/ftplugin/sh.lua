local operator = require "operator"
local region = require "text.region"

vim.opt_local.expandtab = true
vim.opt_local.makeprg = "shellcheck -f gcc"
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.tabstop = 2

vim.opt_local.formatprg = "shfmt -s -i " .. vim.bo.tabstop .. " -bn -ci -sr"

vim.treesitter.start()

vim.keymap.set(
  "n",
  [[<CR>]],
  [[<Cmd>.w !bash<CR>]],
  { buffer = true, desc = "Run current line" }
)
vim.keymap.set("n", [[<leader><CR>]], function()
  local buffer_number = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
  local current_line = cursor[1]

  local region_ = region.from {
    buffer_number = buffer_number,
    line_begin = 1,
    column_begin = 0,
    line_end = current_line,
    column_end = 0,
    type_ = "line",
  }
  vim.api.nvim_put(region_.lines, "l", true, false)
  vim.cmd "'[,']!bash"

  local begin = vim.api.nvim_buf_get_mark(buffer_number, "[")
  local end_ = vim.api.nvim_buf_get_mark(buffer_number, "]")

  if begin[1] <= end_[1] then
    vim.cmd.normal "'[gc']"
  end
end, {
  buffer = true,
  desc = "Paste lines' output from the beginning of the buffer until the current line below",
})
vim.keymap.set(
  "n",
  [[<leader><Tab>]],
  [[<Cmd>up<CR>:new<CR>:terminal bash --init-file #:S<CR>]],
  { buffer = true, desc = "Load current buffer to bash" }
)
vim.keymap.set(
  "v",
  [[<CR>]],
  [[:w !bash<CR>]],
  { buffer = true, desc = "Run selected lines" }
)
vim.keymap.set(
  "v",
  [[<leader><CR>]],
  operator.expr {
    function_ = function(region_)
      vim.cmd "'>"
      vim.api.nvim_put(region_.lines, "l", true, false)
      vim.cmd "'[,']!bash"

      local begin = vim.api.nvim_buf_get_mark(region_.buffer_number, "[")
      local end_ = vim.api.nvim_buf_get_mark(region_.buffer_number, "]")

      if begin[1] <= end_[1] then
        vim.cmd.normal "'[gc']"
      end
    end,
    readonly = true,
  },
  { expr = true, buffer = true, desc = "Paste selected lines' output below" }
)

vim.b.undo_ftplugin = (vim.b.undo_ftplugin and vim.b.undo_ftplugin .. "|" or "")
  .. "setl et< mp< sw< sts< ts< fp<"
  .. "|call v:lua.vim.treesitter.stop()"
  .. "|sil! nunmap <buffer> <CR>|sil! nunmap <buffer> <leader><CR>"
  .. "|sil! nunmap <buffer> <leader><Tab>"
  .. "|sil! vunmap <buffer> <CR>|sil! vunmap <buffer> <leader><CR>"
