local M = {}

local api = vim.api
local deep_equal = vim.deep_equal
local fn = vim.fn

local utils = require "utils"

function M.create_quickfix_list_by_prompt()
  M.create_quickfix_list(fn.input "Enter quickfix list: ")
end

function M.create_quickfix_list(name)
  fn.setqflist({}, " ", { nr = "$", title = name })
end

function M.reset_quickfix_list()
  M.set_quickfix_list_items {}
end

function M.remove_quickfix_list_item(item)
  local items = utils.deepcopy(fn.getqflist())

  local filtered = {}
  for _, x in pairs(items) do
    if not deep_equal(x, item) then
      table.insert(filtered, x)
    end
  end

  M.set_quickfix_list_items(filtered)
end

function M.set_quickfix_list_items(items)
  local quickfix_list = fn.getqflist { all = "" }

  local new_quickfix_list = M.clear_quickfix_list(quickfix_list)
  new_quickfix_list["items"] = items

  fn.setqflist({}, "r", new_quickfix_list)
end

function M.clear_quickfix_list(quickfix_list)
  local new_quickfix_list = {}
  for _, key in pairs { "quickfixtextfunc", "id", "nr", "winid", "title" } do
    new_quickfix_list[key] = quickfix_list[key]
  end
  return new_quickfix_list
end

function M.add_quickfix_list_item(item)
  fn.setqflist({ item }, "a")
end

function M.get_current_quickfix_list_item()
  local items = fn.getqflist()
  return items[fn.getqflist({ idx = 0 }).idx] or {}
end

function M.create_current_position_item()
  local position = fn.getcurpos()
  local line, column = position[2], position[3]
  return {
    filename = api.nvim_buf_get_name(0),
    lnum = line,
    col = column,
    text = fn.getline(line),
  }
end

return M
