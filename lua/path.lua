local M = {}

local utils = require "utils"

function M.step_into(src_dir, dest_dir)
  local xs, ys = utils.split(src_dir, "/"), utils.split(dest_dir, "/")
  local n = utils.prefix_length(xs, ys)

  local prefix = table.concat(ys, "/", 1, n)
  return prefix .. "/" .. (ys[n + 1] or "")
end

function M.extension(path)
  local chunks = utils.split(vim.fs.basename(path), ".")
  table.remove(chunks, 1)
  local extension = table.concat(chunks, ".")
  if #extension > 0 then
    extension = "." .. extension
  end
  return extension
end

return M
