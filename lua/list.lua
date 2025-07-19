local M = {}

local utils = require "utils"

local with_list = {}

function with_list.create(list, name)
  list.set({}, " ", { nr = "$", title = name })
end

function with_list.reset(list)
  with_list.set_items(list, {})
end

function with_list.remove_item(list, item)
  local items = utils.deepcopy(list.get())
  local filtered = vim.tbl_filter(function(x)
    return not vim.deep_equal(x, item)
  end, items)

  with_list.set_items(list, filtered)
end

function with_list.set_items(list, items)
  local xs = list.get { all = "" }

  local ys = M.clear(xs)
  ys["items"] = items

  list.set({}, "r", ys)
end

function M.clear(xs)
  local ys = {}
  for _, key in pairs { "quickfixtextfunc", "id", "nr", "winid", "title" } do
    ys[key] = xs[key]
  end
  return ys
end

function with_list.add_item(list, item)
  list.set({ item }, "a")
end

function with_list.get_current_item(list)
  local items = list.get()
  return items[with_list.get_current_item_index(list)] or {}
end

function with_list.get_current_item_index(list)
  return list.get({ idx = 0 }).idx
end

function with_list.get_title(list)
  return list.get({ title = "" }).title
end

function with_list.set_title(list, title)
  list.set(list.get(), "r", { title = title })
end

function with_list.dump(list)
  local items = list.get()
  local dumped = {}

  for _, item in pairs(items) do
    local d = {
      vim.api.nvim_buf_get_name(item["bufnr"]),
      item["lnum"],
      vim.trim(item["text"]),
    }

    table.insert(dumped, table.concat(d, ":"))
  end

  return dumped
end

function with_list.add_from_buffer(list, buffer)
  return list.add_from_buffer(buffer)
end

function M.create_current_position_item()
  local line, column = utils.get_cursor()
  return {
    filename = vim.api.nvim_buf_get_name(0),
    lnum = line,
    col = column,
    text = vim.fn.getline(line),
  }
end

local function apply_list(list)
  local M = {}
  for name, f in pairs(with_list) do
    M[name] = function(...)
      return f(list, ...)
    end
  end
  return M
end

local sub_M = {
  quickfix = apply_list {
    get = vim.fn.getqflist,
    set = vim.fn.setqflist,
    add_from_buffer = vim.cmd.caddbuffer,
  },
  location = apply_list {
    get = function(...)
      return vim.fn.getloclist(0, ...)
    end,
    set = function(...)
      return vim.fn.setloclist(0, ...)
    end,
    add_from_buffer = vim.cmd.laddbuffer,
  },
}

return vim.tbl_deep_extend("error", M, sub_M)
