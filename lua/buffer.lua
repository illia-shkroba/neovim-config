local M = {}

---@param buffer integer
---@return string
function M.short_name(buffer)
  local absolute = vim.api.nvim_buf_get_name(buffer)
  local relative = vim.fs.relpath(vim.fn.getcwd(), absolute)

  return relative or vim.fn.fnamemodify(absolute, ":~")
end

---@param buffer integer
---@return "scratch"|"normal"
function M.type_(buffer)
  if
    vim.bo[buffer].buftype == "nofile"
    and vim.bo[buffer].bufhidden == "hide"
    and vim.bo[buffer].swapfile == false
  then
    return "scratch"
  else
    return "normal"
  end
end

---@param buffer integer
---@return nil
function M.as_temporary(buffer)
  vim.bo[buffer].buflisted = true
  vim.bo[buffer].buftype = ""
  vim.api.nvim_buf_set_name(buffer, vim.fn.tempname())
end

return M
