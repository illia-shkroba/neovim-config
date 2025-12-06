local M = {}

local fzf = require "fzf-lua"

function M.live_grep_filetype(selected)
  if vim.tbl_contains(selected, "") then
    fzf.live_grep {
      silent = true,
    }
  else
    local type_options = {}

    for _, sel in ipairs(selected) do
      table.insert(type_options, "--type=" .. sel)
    end

    fzf.live_grep {
      winopts = {
        title = " Grep (" .. table.concat(selected, ", ") .. ") ",
      },
      silent = true,
      rg_opts = table.concat(type_options, " ")
        .. " --column --line-number --no-heading --color=always --smart-case"
        .. " --max-columns=4096 -e",
    }
  end
end

return M
