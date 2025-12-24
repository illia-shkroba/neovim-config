local M = {}

---@param region Region
---@param target table<integer, string>|nil
---@return nil
function M.substitute_with_line_ends(region, target)
  target = target or region.lines
  local buffer_lines = vim.api.nvim_buf_get_lines(
    region.buffer_number,
    region.line_begin - 1,
    region.line_end,
    true
  )
  local n = math.min(#buffer_lines, #target)

  local put_lines = {}
  for i = 1, n do
    table.insert(
      put_lines,
      buffer_lines[i]:sub(1, region.column_begin) .. target[i]
    )
  end
  for i = n + 1, #buffer_lines do
    table.insert(put_lines, buffer_lines[i]:sub(1, region.column_begin))
  end

  vim.api.nvim_buf_set_lines(
    region.buffer_number,
    region.line_begin - 1,
    region.line_end,
    false,
    put_lines
  )
end

---@param region Region
---@param target table<integer, string>|nil
---@return nil
function M.substitute_normal(region, target)
  target = target or region.lines
  local buffer_lines = vim.api.nvim_buf_get_lines(
    region.buffer_number,
    region.line_begin - 1,
    region.line_end,
    true
  )
  local n = math.min(#buffer_lines, #target)

  local put_lines = {}
  for i = 1, n do
    table.insert(
      put_lines,
      buffer_lines[i]:sub(1, region.column_begin)
        .. target[i]
        .. buffer_lines[i]:sub(region.column_end + 2)
    )
  end
  for i = n + 1, #buffer_lines do
    table.insert(
      put_lines,
      buffer_lines[i]:sub(1, region.column_begin)
        .. buffer_lines[i]:sub(region.column_end + 2)
    )
  end

  vim.api.nvim_buf_set_lines(
    region.buffer_number,
    region.line_begin - 1,
    region.line_end,
    false,
    put_lines
  )
end

---@param region Region
---@return table<integer, string>
function M.truncate_with_line_ends(region)
  local truncated_lines = {}
  for _, line in pairs(region.lines) do
    table.insert(truncated_lines, line:sub(region.column_begin + 1))
  end
  return truncated_lines
end

---@param region Region
---@return table<integer, string>
function M.truncate_normal(region)
  local truncated_lines = {}
  for _, line in pairs(region.lines) do
    table.insert(
      truncated_lines,
      line:sub(1, region.column_end + 1):sub(region.column_begin + 1)
    )
  end
  return truncated_lines
end

return M
