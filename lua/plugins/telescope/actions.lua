local M = {}

local cmd = vim.cmd
local fn = vim.fn

local action_state = require "telescope.actions.state"
local builtin = require "telescope.builtin"

M.is_hidden_in_find_files = false
function M.toggle_hidden_in_find_files(buffer_number)
  M.is_hidden_in_find_files = not M.is_hidden_in_find_files

  local is_hidden = M.is_hidden_in_find_files or nil
  local find_files = function()
    return builtin.find_files {
      hidden = is_hidden,
      no_ignore = is_hidden,
      no_ignore_parent = is_hidden,
    }
  end

  M.with_line(find_files)(buffer_number)
end

function M.with_line(f)
  local function g(buffer_number)
    local line = action_state.get_current_line(buffer_number)
    f()
    cmd.normal("i" .. line)
  end
  return g
end

function M.remove_files(buffer_number)
  local current_picker = action_state.get_current_picker(buffer_number)
  current_picker:delete_selection(function(selection)
    return pcall(fn.delete, selection.filename)
  end)
end

function M.wipe_out_buffers(buffer_number)
  local current_picker = action_state.get_current_picker(buffer_number)
  current_picker:delete_selection(function(selection)
    return pcall(cmd.bwipeout, selection.bufnr)
  end)
end

return M
