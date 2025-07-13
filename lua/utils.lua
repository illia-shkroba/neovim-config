local M = {}

local read = require "read"

function M.try(f, ...)
  local status, result = pcall(f, ...)
  if status then
    return result
  else
    return nil
  end
end

function M.deepcopy(src)
  if type(src) ~= "table" then
    return src
  end

  local dest = {}
  for k, v in pairs(src) do
    dest[M.deepcopy(k)] = M.deepcopy(v)
  end

  setmetatable(dest, getmetatable(src))
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
  local n = math.min(#xs, #ys)
  for i = 1, n do
    local x, y = xs[i], ys[i]

    if x ~= y then
      return i - 1
    end
  end
  return n
end

function M.map_motion(f)
  M.with_motion(function()
    M.map_visual(f)
  end)
end

function M.get_motion_selection()
  return M.with_motion(function()
    return M.get_visual_selection()
  end)
end

function M.with_motion(f)
  local motion = read.read_motion { allow_forced = false }

  local mode = vim.fn.visualmode()
  local begin_position = vim.fn.getpos "'<"
  local end_position = vim.fn.getpos "'>"

  vim.cmd.normal("v" .. motion.count .. motion.motion .. "")
  local y = f()

  vim.cmd.normal(mode .. "")
  vim.fn.setpos("'<", begin_position)
  vim.fn.setpos("'>", end_position)

  return y
end

function M.map_visual(f)
  local selection = M.get_visual_selection()
  M.with_register(function()
    local new_text = f(selection.text)
    if not new_text then
      return
    end
    vim.fn.setreg('"', new_text)
    vim.cmd.normal "gvp"
    if selection.mode == "v" and selection.ends_with_newline then
      vim.cmd.normal [[a]] -- add newline that was removed during selection
      vim.cmd.normal "gvo" -- go to initial cursor position
    end
  end)
end

function M.get_visual_selection()
  local begin_position = vim.fn.getpos "'<"
  local line_begin, column_begin = begin_position[2], begin_position[3]

  local end_position = vim.fn.getpos "'>"
  local line_end, column_end = end_position[2], end_position[3]

  local lines = vim.fn.getline(line_begin, line_end)

  local result = {
    text = "",
    ends_with_newline = false,
    mode = vim.fn.visualmode(),
    begin = { line_begin, column_begin },
    end_ = { line_end, column_end },
  }

  if #lines == 0 then
    return result
  end

  result.ends_with_newline = column_end > #lines[#lines]
    and line_end < vim.api.nvim_buf_line_count(0)

  lines[#lines] = lines[#lines]:sub(1, column_end)
  lines[1] = lines[1]:sub(column_begin)

  result.text = table.concat(lines, "\n")
  return result
end

function M.with_register(f)
  local old_register = vim.fn.getreg '"'
  local y = f(old_register)
  local new_register = vim.fn.getreg '"'
  vim.fn.setreg('"', old_register)
  return y, new_register
end

function M.get_cursor()
  local position = vim.fn.getcurpos()
  local line, column = position[2], position[3]
  return line, column
end

return M
