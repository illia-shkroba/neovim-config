local M = {}

local cmd = vim.cmd
local fn = vim.fn

local action_state = require "telescope.actions.state"
local builtin = require "telescope.builtin"

function M.hide_in_find_files(buffer_number)
  local find_files = function()
    builtin.find_files {
      hidden = nil,
      no_ignore = nil,
      no_ignore_parent = nil,
    }
  end
  M.with_line(find_files)(buffer_number)
end

function M.unhide_in_find_files(buffer_number)
  local find_files = function()
    builtin.find_files {
      hidden = true,
      no_ignore = true,
      no_ignore_parent = true,
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
