local M = {}

local utils = require "utils"

function M.step_into(src_dir, dest_dir)
  local xs, ys = utils.split(src_dir, "/"), utils.split(dest_dir, "/")
  local n = utils.prefix_length(xs, ys)

  local prefix = table.concat(ys, "/", 1, n)
  return prefix .. "/" .. (ys[n + 1] or "")
end

return M
