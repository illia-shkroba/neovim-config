local M = {}

local api = vim.api
local deep_equal = vim.deep_equal
local fn = vim.fn

local utils = require "utils"

function M.create_by_prompt()
  M.create(fn.input "Enter quickfix list: ")
end

function M.create(name)
  fn.setqflist({}, " ", { nr = "$", title = name })
end

function M.reset()
  M.set_items {}
end

function M.remove_item(item)
  local items = utils.deepcopy(fn.getqflist())

  local filtered = {}
  for _, x in pairs(items) do
    if not deep_equal(x, item) then
      table.insert(filtered, x)
    end
  end

  M.set_items(filtered)
end

function M.set_items(items)
  local quickfix = fn.getqflist { all = "" }

  local new_quickfix = M.clear(quickfix)
  new_quickfix["items"] = items

  fn.setqflist({}, "r", new_quickfix)
end

function M.clear(quickfix)
  local new_quickfix = {}
  for _, key in pairs { "quickfixtextfunc", "id", "nr", "winid", "title" } do
    new_quickfix[key] = quickfix[key]
  end
  return new_quickfix
end

function M.add_item(item)
  fn.setqflist({ item }, "a")
end

function M.get_current_item()
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
