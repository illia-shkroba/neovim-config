local M = {}

---@param region Region
---@param target table<integer, string>
---@return nil
function M.substitute(region, target)
  vim.api.nvim_buf_set_text(
    region.buffer_number,
    region.line_begin - 1,
    region.column_begin,
    region.line_end - 1,
    region.column_end + 1,
    target
  )
end

---@param region Region
---@return table<integer, string>
function M.truncate(region)
  local lines = region.lines

  if #lines == 0 then
    return lines
  end

  local truncated_lines = vim.deepcopy(lines)
  truncated_lines[#lines] = lines[#lines]:sub(1, region.column_end + 1)
  truncated_lines[1] = truncated_lines[1]:sub(region.column_begin + 1)
  return truncated_lines
end

return M
