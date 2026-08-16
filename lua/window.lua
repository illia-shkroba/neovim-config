local M = {}

---Move `window` to a vertical split right of the last accessed window.
---@param window integer
---@return integer|nil
function M.to_vertical(window)
  local last_accessed_window = vim.api.nvim_win_call(window, function()
    return vim.fn.win_getid(vim.fn.winnr "#")
  end)

  if last_accessed_window == 0 or last_accessed_window == window then
    vim.notify("No last accessed window.", vim.log.levels.INFO)
    return nil
  end

  local buffer_ = vim.api.nvim_win_get_buf(window)
  local new_window = vim.api.nvim_open_win(buffer_, true, {
    split = "right",
    win = last_accessed_window,
  })

  local cursor = vim.api.nvim_win_get_cursor(window)
  vim.api.nvim_win_set_cursor(new_window, cursor)

  vim.wo[new_window].statusline = vim.wo[window].statusline

  vim.api.nvim_win_close(window, true)
  vim.api.nvim_set_current_win(last_accessed_window)
  vim.api.nvim_set_current_win(new_window)

  return new_window
end

return M
