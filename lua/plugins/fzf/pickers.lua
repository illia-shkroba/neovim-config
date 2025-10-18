local M = {}

local fzf = require "fzf-lua"

function M.live_grep_filetype()
  local current_filetype = vim.opt_local.filetype._value
  local filetypes = vim.fn.getcompletion("", "filetype")

  -- "" file type resembles "no file type". After "" file type is selected,
  -- `live_grep_filetype` works as a plain `live_grep`.
  table.insert(filetypes, 1, "")

  -- Put `current_filetype` first in the result's list.
  if current_filetype ~= "" then
    filetypes = vim.tbl_filter(function(x)
      return x ~= current_filetype
    end, filetypes)
    table.insert(filetypes, 1, current_filetype)
  end

  fzf.fzf_exec(filetypes, {
    winopts = {
      title = " Filetypes (Live Grep) ",
    },
    actions = {
      ["enter"] = function(selected)
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
            rg_opts = table.concat(type_options, " "),
          }
        end
      end,
    },
  })
end

return M
