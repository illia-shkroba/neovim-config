local M = {}

local cmd = vim.cmd
local fn = vim.fn
local v = vim.v

function M.down(selection)
  cmd {
    cmd = "move",
    args = { math.min(selection.end_[1] + v.count1, fn.line "$") },
    range = { selection.begin[1], selection.end_[1] },
  }
end

function M.up(selection)
  cmd {
    cmd = "move",
    args = { math.max(selection.begin[1] - v.count1 - 1, 0) },
    range = { selection.begin[1], selection.end_[1] },
  }
end

return M
