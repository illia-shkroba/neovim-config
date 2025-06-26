local M = {}

function M.down(selection)
  vim.cmd {
    cmd = "move",
    args = { math.min(selection.end_[1] + vim.v.count1, vim.fn.line "$") },
    range = { selection.begin[1], selection.end_[1] },
  }
end

function M.up(selection)
  vim.cmd {
    cmd = "move",
    args = { math.max(selection.begin[1] - vim.v.count1 - 1, 0) },
    range = { selection.begin[1], selection.end_[1] },
  }
end

return M
