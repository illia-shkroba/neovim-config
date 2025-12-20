local M = {}

local fzf = require "fzf-lua"
local filetypes = require "filetypes"

function M.grep_filetype(opts)
  opts = opts or {}
  opts.winopts = opts.winopts ~= nil and opts.winopts
    or {
      title = " Filetypes Grep ",
    }

  local matching_filetypes = filetypes.match_rg(vim.opt_local.filetype._value)
  local all_filetypes = vim.deepcopy(filetypes.rg)

  local other_filetypes = vim.tbl_filter(function(x)
    return not vim.tbl_contains(matching_filetypes, x)
  end, all_filetypes)

  for _, filetype in pairs(other_filetypes) do
    table.insert(matching_filetypes, filetype)
  end

  -- "" file type resembles "no file type".
  table.insert(matching_filetypes, 1, "")

  fzf.fzf_exec(matching_filetypes, opts)
end

return M
