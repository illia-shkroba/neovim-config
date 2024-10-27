local M = {}

local fn = vim.fn
local opt_local = vim.opt_local

local action_state = require "telescope.actions.state"
local actions = require "telescope.actions"
local builtin = require "telescope.builtin"
local finders = require "telescope.finders"
local utils = require "telescope.utils"

function M.live_grep_filetype(opts)
  local current_filetype = opt_local.filetype._value
  local filetypes = fn.getcompletion("", "filetype")

  -- "" file type resembles "no file type". After "" file type is selected,
  -- `live_grep_filetype` works as a plain `live_grep`.
  table.insert(filetypes, 1, "")

  -- Put current_filetype first in the results list.
  if current_filetype ~= "" then
    filetypes = vim.tbl_filter(function(x)
      return x ~= current_filetype
    end, filetypes)
    table.insert(filetypes, 1, current_filetype)
  end

  local new_opts = vim.tbl_deep_extend("keep", {
    prompt_title = "Filetypes (Live Grep)",
    finder = finders.new_table {
      results = filetypes,
    },
    attach_mappings = function()
      actions.select_default:replace(function(prompt_buffer)
        local selection = action_state.get_selected_entry()
        if selection == nil then
          utils.__warn_no_selection "actions.paste_register"
          return
        end
        actions.close(prompt_buffer)
        if selection[1] ~= "" then
          builtin.live_grep {
            prompt_title = "Live Grep (" .. selection[1] .. ")",
            type_filter = selection[1],
          }
        else
          builtin.live_grep()
        end
      end)
      return true
    end,
  }, opts or {})
  builtin.filetypes(new_opts)
end

return M
