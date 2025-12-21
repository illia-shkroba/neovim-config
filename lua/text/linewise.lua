local M = {}

local text = require "text"

---@param region Region
---@param target table<integer, string>|nil
---@return nil
function M.substitute(region, target)
  target = target or region.lines
  local end_of_file = region.line_end
    == vim.api.nvim_buf_line_count(region.buffer_number)
  vim.cmd.normal "'[\"_d']"

  local empty_buffer_before_put = text.empty_buffer(region.buffer_number)
  vim.api.nvim_put(target, "l", end_of_file, false)

  -- Remove empty line on top of the file after put.
  if end_of_file and empty_buffer_before_put then
    M.remove_top_empty_line(region.buffer_number)
  end
end

---@param buffer_number integer
---@return nil
function M.remove_top_empty_line(buffer_number)
  -- Keep the `'[` and `']` marks.
  local changed_begin = vim.api.nvim_buf_get_mark(buffer_number, "[")
  local changed_end = vim.api.nvim_buf_get_mark(buffer_number, "]")

  vim.cmd.normal 'gg"_dd'

  vim.api.nvim_buf_set_mark(
    buffer_number,
    "[",
    changed_begin[1] - 1,
    changed_begin[2],
    {}
  )
  vim.api.nvim_buf_set_mark(
    buffer_number,
    "]",
    changed_end[1] - 1,
    changed_end[2],
    {}
  )
end

return M
