local M = {}

local action_state = require "telescope.actions.state"
local builtin = require "telescope.builtin"

M.is_hidden_in_find_files = false
function M.toggle_hidden_in_find_files(buffer_number)
  local find_files
  if M.is_hidden_in_find_files then
    find_files = builtin.find_files
  else
    find_files = function()
      return builtin.find_files {
        hidden = true,
        no_ignore = true,
        no_ignore_parent = true,
      }
    end
  end

  M.is_hidden_in_find_files = not M.is_hidden_in_find_files

  M.with_line(find_files)(buffer_number)
end

function M.with_line(f)
  local function g(buffer_number)
    local line = action_state.get_current_line(buffer_number)
    f()
    vim.cmd.normal("i" .. line)
  end
  return g
end

return M
