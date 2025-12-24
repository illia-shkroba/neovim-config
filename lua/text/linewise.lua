local M = {}

---@param region Region
---@param target table<integer, string>
---@return nil
function M.substitute(region, target)
  vim.api.nvim_buf_set_lines(
    region.buffer_number,
    region.line_begin - 1,
    region.line_end,
    false,
    target
  )
end

return M
