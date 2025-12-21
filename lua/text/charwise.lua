local M = {}

local text = require "text"

---@param region Region
---@param target table<integer, string>|nil
---@return nil
function M.substitute(region, target)
  target = target or region.lines
  vim.cmd.normal '`["_dv`]'
  vim.api.nvim_put(target, "c", text.ends_with_eol(region), false)
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
