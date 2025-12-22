local M = {}

local mark = require "mark"
local text = require "text"

---@param region Region
---@param target table<integer, string>|nil
---@return nil
function M.substitute(region, target)
  target = target or region.lines
  local end_of_file = region.line_end
    == vim.api.nvim_buf_line_count(region.buffer_number)

  vim.api.nvim_buf_set_lines(
    region.buffer_number,
    region.line_begin - 1,
    region.line_end,
    false,
    {}
  )

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
  mark.with_marks {
    buffer_number = buffer_number,
    marks = { "[", "]" },
    function_ = function()
      vim.api.nvim_buf_set_lines(buffer_number, 0, 1, false, {})
    end,
  }
end

return M
