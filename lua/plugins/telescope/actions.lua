local M = {}

local action_state = require "telescope.actions.state"
local builtin = require "telescope.builtin"

function M.hide_in_find_files(buffer_number)
  local function find_files()
    local current_picker = action_state.get_current_picker(buffer_number)
    builtin.find_files {
      cwd = current_picker.cwd,
      hidden = nil,
      no_ignore = nil,
      no_ignore_parent = nil,
    }
  end
  M.with_line(find_files)(buffer_number)
end

function M.unhide_in_find_files(buffer_number)
  local function find_files()
    local current_picker = action_state.get_current_picker(buffer_number)
    builtin.find_files {
      cwd = current_picker.cwd,
      hidden = true,
      no_ignore = true,
      no_ignore_parent = true,
    }
  end
  M.with_line(find_files)(buffer_number)
end

local function search_string(picker)
  return picker.prompt_title:gsub("^.* %(", ""):gsub("%)", "")
end

function M.search_globally_in_grep_string(buffer_number)
  local function grep_string()
    local current_picker = action_state.get_current_picker(buffer_number)
    builtin.grep_string {
      cwd = current_picker.cwd,
      search = search_string(current_picker),
      word_match = "-w",
    }
  end
  M.with_line(grep_string)(buffer_number)
end

function M.search_globally_in_live_grep(buffer_number)
  local function live_grep()
    local current_picker = action_state.get_current_picker(buffer_number)
    builtin.live_grep {
      cwd = current_picker.cwd,
    }
  end
  M.with_line(live_grep)(buffer_number)
end

function M.with_line(f)
  local function g(buffer_number)
    local line = action_state.get_current_line(buffer_number)
    f()
    vim.cmd.normal("i" .. line)
  end
  return g
end

function M.remove_files(buffer_number)
  local current_picker = action_state.get_current_picker(buffer_number)
  current_picker:delete_selection(function(selection)
    return pcall(vim.fn.delete, selection.filename)
  end)
end

function M.wipe_out_buffers(buffer_number)
  local current_picker = action_state.get_current_picker(buffer_number)
  current_picker:delete_selection(function(selection)
    return pcall(vim.cmd.bwipeout, selection.bufnr)
  end)
end

local function selected_entries(buffer_number)
  local picker = action_state.get_current_picker(buffer_number)

  local es = {}
  for _, e in ipairs(picker:get_multi_selection()) do
    table.insert(es, e)
  end

  return es
end

local function all_entries(buffer_number)
  local picker = action_state.get_current_picker(buffer_number)
  local manager = picker.manager

  local es = {}
  for e in manager:iter() do
    table.insert(es, e)
  end

  return es
end

local function entries(buffer_number)
  local picker = action_state.get_current_picker(buffer_number)
  if #picker:get_multi_selection() > 0 then
    return selected_entries(buffer_number)
  else
    return all_entries(buffer_number)
  end
end

function M.add_arguments(buffer_number)
  local es = entries(buffer_number)
  for _, e in pairs(es) do
    vim.cmd.argadd(e.filename)
  end
  vim.cmd.argdedupe()
end

return M
