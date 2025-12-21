local M = {}

local text = require "text"
local linewise = require "text.linewise"

---@param region Region
---@param target table<integer, string>|nil
---@return nil
function M.substitute_with_line_ends(region, target)
  target = target or region.lines
  local put_lines = {}
  local n = math.min(#region.lines, #target)
  for i = 1, n do
    table.insert(
      put_lines,
      region.lines[i]:sub(1, region.column_begin) .. target[i]
    )
  end
  for i = n + 1, #region.lines do
    table.insert(put_lines, region.lines[i]:sub(1, region.column_begin))
  end

  local end_of_file = region.line_end
    == vim.api.nvim_buf_line_count(region.buffer_number)
  vim.cmd.normal "'[\"_d']"

  local empty_buffer_before_put = text.empty_buffer(region.buffer_number)
  vim.api.nvim_put(put_lines, "l", end_of_file, false)

  -- Remove empty line on top of the file after put.
  if end_of_file and empty_buffer_before_put then
    linewise.remove_top_empty_line(region.buffer_number)
  end
end

---@param region Region
---@param target table<integer, string>|nil
---@return nil
function M.substitute_normal(region, target)
  target = target or region.lines
  vim.cmd.normal '`["_d`]'
  vim.api.nvim_put(target, "b", false, false)
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
