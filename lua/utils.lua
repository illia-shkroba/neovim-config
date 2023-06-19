local M = {}

local api = vim.api
local cmd = vim.cmd
local fn = vim.fn

local read = require "read"

function M.require_safe(module_name)
  return M.try(require, module_name)
end

function M.try(f, ...)
  local status, result = pcall(f, ...)
  if status then
    return result
  else
    return nil
  end
end

function M.union(first, last)
  if type(first) == "table" and type(last) == "table" then
    return M.union_tables(first, last)
  else
    return first
  end
end

function M.union_tables(first, last)
  local dest = M.deepcopy(first)
  for k, v2 in pairs(last) do
    local v1 = dest[k]
    if v1 == nil then
      dest[k] = M.deepcopy(v2)
    else
      dest[k] = M.union(v1, v2)
    end
  end
  return dest
end

function M.deepcopy(src)
  if type(src) ~= "table" then
    return src
  end

  local dest = {}
  for k, v in pairs(src) do
    dest[M.deepcopy(k)] = M.deepcopy(v)
  end
  return dest
end

function M.split(xs, sep)
  local parts = {}

  local begin, end_ = 1, 0
  local i = 1
  while i <= #xs do
    local ys = xs:sub(i, i + #sep - 1)
    if ys == sep then
      table.insert(parts, xs:sub(begin, end_))

      i = i + #sep
      begin = i
      end_ = begin - 1
    else
      i = i + 1
      end_ = end_ + 1
    end
  end

  table.insert(parts, xs:sub(begin, end_))

  return parts
end

function M.prefix_length(xs, ys)
  local n = M.min(#xs, #ys)
  for i = 1, n do
    local x, y = xs[i], ys[i]

    if x ~= y then
      return i - 1
    end
  end
  return n
end

function M.min(x, y)
  if x <= y then
    return x
  else
    return y
  end
end

function M.max(x, y)
  if x >= y then
    return x
  else
    return y
  end
end

function M.map_motion(f)
  M.with_motion(function()
    M.map_visual(f)
  end)
end

function M.get_motion_selection()
  return M.with_motion(function()
    return M.get_visual_selection().text
  end)
end

function M.with_motion(f)
  local motion = read.read_motion { allow_forced = false }

  local mode = fn.visualmode()
  local begin_position = fn.getpos "'<"
  local end_position = fn.getpos "'>"

  cmd.normal("v" .. motion.count .. motion.motion .. "")
  local y = f()

  cmd.normal(mode .. "")
  fn.setpos("'<", begin_position)
  fn.setpos("'>", end_position)

  return y
end

function M.map_visual(f)
  local selection = M.get_visual_selection()
  local register = fn.getreg '"'

  fn.setreg('"', f(selection.text))
  cmd.normal "gvp"
  if selection.mode == "v" and selection.ends_with_newline then
    cmd.normal [[a]] -- add newline that was removed during selection
    cmd.normal "gvo" -- go to initial cursor position
  end
  fn.setreg('"', register)
end

function M.get_visual_selection()
  local begin_position = fn.getpos "'<"
  local line_begin, column_begin = begin_position[2], begin_position[3]

  local end_position = fn.getpos "'>"
  local line_end, column_end = end_position[2], end_position[3]

  local lines = fn.getline(line_begin, line_end)

  local result = {
    text = "",
    ends_with_newline = false,
    mode = fn.visualmode(),
  }

  if #lines == 0 then
    return result
  end

  result.ends_with_newline = column_end > #lines[#lines]
    and line_end < api.nvim_buf_line_count(0)

  lines[#lines] = lines[#lines]:sub(1, column_end)
  lines[1] = lines[1]:sub(column_begin)

  result.text = table.concat(lines, "\n")
  return result
end

function M.quote(text)
  local quote = fn.getcharstr()
  return quote .. text .. quote
end

return M
