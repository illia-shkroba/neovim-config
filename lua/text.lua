local M = {}

---@param region Region
---@return boolean
function M.ends_with_eol(region)
  local lines = region.lines
  if #lines > 0 then
    return (region.column_end + 1) >= #lines[#lines]
  else
    return false
  end
end

---@param region Region
---@return boolean
function M.ends_with_newline(region)
  local column_end = region.column_end
  local lines = region.lines

  if #lines > 0 then
    return column_end + 1 > #lines[#lines]
  else
    return false
  end
end

-- Lift function to work with lines.
---@param f fun(string, ...): string
---@return fun(table, ...): table<integer, string>
function M.with_lines(f)
  return function(lines, ...)
    local xs = table.concat(lines, "\n")
    return vim.split(f(xs, ...), "\n")
  end
end

---@param buffer_number integer
---@return boolean
function M.empty_buffer(buffer_number)
  return vim.api.nvim_buf_line_count(buffer_number) == 1
    and vim.api.nvim_buf_get_lines(buffer_number, 0, 1, true)[1] == ""
end

return M
