local M = {}

local fzf = require "fzf-lua"
local filetypes = require "filetypes"

function M.rg_filetypes(opts)
  opts = opts or {}
  opts.winopts = opts.winopts ~= nil and opts.winopts
    or {
      title = " Filetypes Grep ",
    }

  local all_filetypes = vim.deepcopy(filetypes.rg)
  -- "" file type resembles "no file type".
  table.insert(all_filetypes, 1, "")
  fzf.fzf_exec(all_filetypes, opts)
end

return M
