local M = {}

local fzf = require "fzf-lua"

function M.grep_filetype(opts)
  opts = opts or {}
  opts.winopts = opts.winopts ~= nil and opts.winopts
    or {
      title = " Filetypes Grep ",
    }

  local current_filetype = vim.opt_local.filetype._value
  local filetypes = vim.fn.getcompletion("", "filetype")

  -- "" file type resembles "no file type".
  table.insert(filetypes, 1, "")

  -- Put `current_filetype` first in the result's list.
  if current_filetype ~= "" then
    filetypes = vim.tbl_filter(function(x)
      return x ~= current_filetype
    end, filetypes)
    table.insert(filetypes, 1, current_filetype)
  end

  fzf.fzf_exec(filetypes, opts)
end

return M
