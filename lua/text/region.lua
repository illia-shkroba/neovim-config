local M = {}

local blockwise = require "text.blockwise"
local charwise = require "text.charwise"
local linewise = require "text.linewise"
local text = require "text"

---@param region Region
---@param target table<integer, string>|nil
---@return nil
function M.substitute(region, target)
  target = target or region.lines
  if region.type_ == "line" then
    linewise.substitute(region, target)
  elseif region.type_ == "char" then
    charwise.substitute(region, target)
  elseif region.type_ == "block" and text.ends_with_newline(region) then
    blockwise.substitute_with_line_ends(region, target)
  elseif region.type_ == "block" and not text.ends_with_newline(region) then
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
  elseif region.type_ == "block" and text.ends_with_newline(region) then
    return blockwise.truncate_with_line_ends(region)
  elseif region.type_ == "block" and not text.ends_with_newline(region) then
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
