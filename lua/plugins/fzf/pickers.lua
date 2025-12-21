local M = {}

local fzf = require "fzf-lua"
local filetypes = require "filetypes"

function M.grep_by_filetype(search, selected)
  if vim.tbl_contains(selected, "") then
    fzf.grep {
      silent = true,
      search = search,
    }
  else
    local type_options = {}

    for _, sel in ipairs(selected) do
      table.insert(type_options, "--type=" .. sel)
    end

    fzf.grep {
      winopts = {
        title = " Grep (" .. table.concat(selected, ", ") .. ") ",
      },
      silent = true,
      search = search,
      rg_opts = table.concat(type_options, " ")
        .. " --column --line-number --no-heading --color=always --smart-case"
        .. " --max-columns=4096 -e",
    }
  end
end

function M.live_grep_by_filetype(selected)
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
