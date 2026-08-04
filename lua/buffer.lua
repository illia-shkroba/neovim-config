local M = {}

---@param buffer integer
---@return string
function M.short_name(buffer)
  local absolute = M.name(buffer)
  local relative = vim.fs.relpath(vim.fn.getcwd(), absolute)

  return relative or vim.fn.fnamemodify(absolute, ":~")
end

---@param buffer integer
---@return string
function M.name(buffer)
  return M.netrw_dir(buffer) or vim.api.nvim_buf_get_name(buffer)
end

---@param buffer integer
---@return string
function M.dirname(buffer)
  return M.netrw_dir(buffer)
    or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buffer), ":p:h")
end

---@param buffer integer
---@return string|nil
function M.netrw_dir(buffer)
  if vim.bo[buffer].filetype ~= "netrw" then
    return nil
  end

  local dir = vim.b[buffer].netrw_curdir
  if dir ~= "" then
    return dir
  else
    return nil
  end
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
