local M = {}

local region = require "text.region"

local namespace = vim.api.nvim_create_namespace "tracked_region"

---@class TrackedRegion
---@field mark_begin integer
---@field mark_end integer
---@field region Region

---@param tracked TrackedRegion
---@return nil
local function update_inplace(tracked)
  local mark_begin = vim.api.nvim_buf_get_extmark_by_id(
    tracked.region.buffer_number,
    namespace,
    tracked.mark_begin,
    {}
  )
  local mark_end = vim.api.nvim_buf_get_extmark_by_id(
    tracked.region.buffer_number,
    namespace,
    tracked.mark_end,
    {}
  )

  -- If `substitute_linewise` is called with a region having `line_begin = 1`
  -- and an empty `target`, then resulting `Region` will have `line_end = 0`.
  local new_line_end
  if tracked.region.line_end == 0 and mark_end[1] == 0 then
    new_line_end = 0
  else
    new_line_end = mark_end[1] + 1
  end

  -- If `substitute_charwise` is called with a region having `column_begin = 0`
  -- and an empty `target`, then resulting `Region` will have `column_end = -1`.
  -- According to the `:help api-indexing` -1 denotes the last column.
  local new_column_end
  if tracked.region.column_end == -1 and mark_end[2] == 0 then
    new_column_end = -1
  else
    new_column_end = mark_end[2]
  end

  local ok, new_region = pcall(region.update, tracked.region, {
    line_begin = mark_begin[1] + 1,
    column_begin = mark_begin[2],
    line_end = new_line_end,
    column_end = new_column_end,
  })

  if ok then
    tracked.region = new_region
  else
    vim.notify(
      "Unable to update substitute region from extmarks; using previous region.",
      vim.log.levels.INFO
    )
  end
end

---@param tracked TrackedRegion
---@param target table<integer, string>
---@return TrackedRegion
function M.substitute(tracked, target)
  update_inplace(tracked)

  local substitute_region = region.substitute(tracked.region, target)

  vim.api.nvim_buf_del_extmark(
    tracked.region.buffer_number,
    namespace,
    tracked.mark_begin
  )
  vim.api.nvim_buf_del_extmark(
    tracked.region.buffer_number,
    namespace,
    tracked.mark_end
  )

  return M.from_region(substitute_region)
end

---@param region_ Region
---@return TrackedRegion
function M.from_region(region_)
  local column_begin, column_end
  if region_.type_ == "line" then
    column_begin, column_end = 0, 0
  else
    column_begin, column_end = region_.column_begin, region_.column_end
  end

  local mark_begin = vim.api.nvim_buf_set_extmark(
    region_.buffer_number,
    namespace,
    region_.line_begin - 1,
    column_begin,
    { right_gravity = true, undo_restore = true }
  )
  local mark_end = vim.api.nvim_buf_set_extmark(
    region_.buffer_number,
    namespace,
    -- If `substitute_linewise` is called with a region having `line_begin = 1`
    -- and an empty `target`, then resulting `Region` will have `line_end = 0`.
    math.max(region_.line_end - 1, 0),
    -- If `substitute_charwise` is called with a region having `column_begin = 0`
    -- and an empty `target`, then resulting `Region` will have `column_end = -1`.
    -- According to the `:help api-indexing` -1 denotes the last column.
    math.max(column_end, 0),
    { right_gravity = true, undo_restore = true }
  )

  return { mark_begin = mark_begin, mark_end = mark_end, region = region_ }
end

---@param tracked TrackedRegion
---@return table<integer, string>
function M.lines(tracked)
  update_inplace(tracked)
  return tracked.region.lines
end

return M
