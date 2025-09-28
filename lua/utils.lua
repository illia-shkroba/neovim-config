local M = {}

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

function M.get_linewise_selection()
  local begin_position = vim.fn.getpos "'<"
  local line_begin = begin_position[2]

  local end_position = vim.fn.getpos "'>"
  local line_end = end_position[2]

  local lines = vim.api.nvim_buf_get_lines(
    vim.api.nvim_get_current_buf(),
    line_begin - 1,
    line_end,
    true
  )

  return {
    lines = lines,
    mode = vim.fn.visualmode(),
    begin = line_begin,
    end_ = line_end,
  }
end

function M.get_cursor()
  local position = vim.fn.getcurpos()
  local line, column = position[2], position[3]
  return line, column
end

return M
