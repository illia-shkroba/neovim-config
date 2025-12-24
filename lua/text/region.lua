local M = {}

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

---@param region Region
---@param target table<integer, string>
---@return nil
local function substitute_linewise(region, target)
  vim.api.nvim_buf_set_lines(
    region.buffer_number,
    region.line_begin - 1,
    region.line_end,
    false,
    target
  )
end

---@param region Region
---@param target table<integer, string>
---@return nil
local function substitute_charwise(region, target)
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
---@param target table<integer, string>
---@return nil
local function substitute_blockwise_with_line_ends(region, target)
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
---@param target table<integer, string>
---@return nil
local function substitute_blockwise_normal(region, target)
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
---@param target table<integer, string>
---@return nil
function M.substitute(region, target)
  if region.type_ == "line" then
    substitute_linewise(region, target)
  elseif region.type_ == "char" then
    substitute_charwise(region, target)
  elseif region.type_ == "block_newline" then
    substitute_blockwise_with_line_ends(region, target)
  elseif region.type_ == "block" then
    substitute_blockwise_normal(region, target)
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
local function truncate_charwise(region)
  local lines = region.lines

  if #lines == 0 then
    return lines
  end

  local truncated_lines = vim.deepcopy(lines)
  truncated_lines[#lines] = lines[#lines]:sub(1, region.column_end + 1)
  truncated_lines[1] = truncated_lines[1]:sub(region.column_begin + 1)
  return truncated_lines
end

---@param region Region
---@return table<integer, string>
local function truncate_blockwise_with_line_ends(region)
  local truncated_lines = {}
  for _, line in pairs(region.lines) do
    table.insert(truncated_lines, line:sub(region.column_begin + 1))
  end
  return truncated_lines
end

---@param region Region
---@return table<integer, string>
local function truncate_blockwise_normal(region)
  local truncated_lines = {}
  for _, line in pairs(region.lines) do
    table.insert(
      truncated_lines,
      line:sub(1, region.column_end + 1):sub(region.column_begin + 1)
    )
  end
  return truncated_lines
end

---@param region Region
---@return table<integer, string>
local function truncate(region)
  if region.type_ == "line" then
    return region.lines
  elseif region.type_ == "char" then
    return truncate_charwise(region)
  elseif region.type_ == "block_newline" then
    return truncate_blockwise_with_line_ends(region)
  elseif region.type_ == "block" then
    return truncate_blockwise_normal(region)
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
  region.lines = truncate(region)

  return region
end

return M
