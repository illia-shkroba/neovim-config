local M = {}

---@param xs table<integer, string>
---@param ys table<integer, string>
---@return integer
local function prefix_length(xs, ys)
  local n = math.min(#xs, #ys)
  for i = 1, n do
    local x, y = xs[i], ys[i]

    if x ~= y then
      return i - 1
    end
  end
  return n
end

---@param src_dir string
---@param dest_dir string
---@return string
function M.step_into(src_dir, dest_dir)
  local xs, ys = vim.split(src_dir, "/"), vim.split(dest_dir, "/")
  local n = prefix_length(xs, ys)

  local prefix = table.concat(ys, "/", 1, n)
  return vim.fs.joinpath(prefix, ys[n + 1] or "")
end

---@param path string
---@return boolean
function M.remote(path)
  return vim
    .iter({
      "^file://",
      "^ftp://",
      "^rcp://",
      "^scp://",
      "^dav://",
      "^davs://",
      "^rsync://",
      "^sftp://",
    })
    :any(function(v)
      return path:match(v) ~= nil
    end)
end

return M
