local M = {}

local blockwise = require "text.blockwise"
local charwise = require "text.charwise"
local linewise = require "text.linewise"

---@class Region
---@field buffer_number integer
---@field line_begin integer
---@field column_begin integer
---@field line_end integer
---@field column_end integer
---@field type_ "line"|"char"|"block"|"block_newline"
---@field lines table<integer, string>

---@class RegionInput
---@field buffer_number integer
---@field line_begin integer
---@field column_begin integer
---@field line_end integer
---@field column_end integer
---@field type_ "line"|"char"|"block"

---@param region_input RegionInput
---@return Region
function M.from(region_input)
  local lines = vim.api.nvim_buf_get_lines(
    region_input.buffer_number,
    region_input.line_begin - 1,
    region_input.line_end,
    true
  )

  local type_
  if
    region_input.type_ == "block"
    and #lines > 0
    and region_input.column_end + 1 > #lines[#lines]
  then
    type_ = "block_newline"
  else
    type_ = region_input.type_
  end

  local region = {
    buffer_number = region_input.buffer_number,
    line_begin = region_input.line_begin,
    column_begin = region_input.column_begin,
    line_end = region_input.line_end,
    column_end = region_input.column_end,
    type_ = type_,
    lines = lines,
  }
  region.lines = M.truncate(region)

  return region
end

---@param region Region
---@param target table<integer, string>
---@return nil
function M.substitute(region, target)
  if region.type_ == "line" then
    linewise.substitute(region, target)
  elseif region.type_ == "char" then
    charwise.substitute(region, target)
  elseif region.type_ == "block_newline" then
    blockwise.substitute_with_line_ends(region, target)
  elseif region.type_ == "block" then
    blockwise.substitute_normal(region, target)
  else
    vim.notify(
      [[Invalid `region.type_ = "]]
        .. region.type_
        .. [["` passed to `substitute`.]],
      vim.log.levels.WARN
    )
  end
end

---@param region Region
---@return table<integer, string>
function M.truncate(region)
  if region.type_ == "line" then
    return region.lines
  elseif region.type_ == "char" then
    return charwise.truncate(region)
  elseif region.type_ == "block_newline" then
    return blockwise.truncate_with_line_ends(region)
  elseif region.type_ == "block" then
    return blockwise.truncate_normal(region)
  else
    vim.notify(
      [[Invalid `region.type_ = "]]
        .. region.type_
        .. [["` passed to `truncate`.]],
      vim.log.levels.WARN
    )
    return region.lines
  end
end

return M
