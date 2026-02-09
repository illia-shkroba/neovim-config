local M = {}

local region = require "text.region"

local namespace = vim.api.nvim_create_namespace "tracked_region"

---@class TrackedRegion
---@field mark_begin integer
---@field mark_end integer
---@field region Region

---@param tracked TrackedRegion
---@param target table<integer, string>
---@return TrackedRegion
function M.substitute(tracked, target)
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

  local ok, new_region = pcall(region.update, tracked.region, {
    line_begin = mark_begin[1] + 1,
    column_begin = mark_begin[2],
    line_end = mark_end[1] + 1,
    column_end = mark_end[2],
  })

  if not ok then
    vim.notify(
      "Unable to update substitute region from extmarks; using previous region.",
      vim.log.levels.INFO
    )
    new_region = tracked.region
  end

  local substitute_region = region.substitute(new_region, target)

  vim.api.nvim_buf_del_extmark(
    new_region.buffer_number,
    namespace,
    tracked.mark_begin
  )
  vim.api.nvim_buf_del_extmark(
    new_region.buffer_number,
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
    region_.line_end - 1,
    column_end,
    { right_gravity = true, undo_restore = true }
  )

  return { mark_begin = mark_begin, mark_end = mark_end, region = region_ }
end

return M
