local M = {}

function M.down(begin, end_)
  vim.cmd {
    cmd = "move",
    args = { math.min(end_[1] + vim.v.count1, vim.fn.line "$") },
    range = { begin[1], end_[1] },
  }
end

function M.up(begin, end_)
  vim.cmd {
    cmd = "move",
    args = { math.max(begin[1] - vim.v.count1 - 1, 0) },
    range = { begin[1], end_[1] },
  }
end

return M
