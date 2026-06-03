local M = {}

---@param buffer integer
---@return string
function M.short_name(buffer)
  local absolute = vim.api.nvim_buf_get_name(buffer)
  local relative = vim.fs.relpath(vim.fn.getcwd(), absolute)

  return relative or vim.fn.fnamemodify(absolute, ":~")
end

return M
