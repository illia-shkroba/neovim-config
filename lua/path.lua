local M = {}

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

function M.step_into(src_dir, dest_dir)
  local xs, ys = vim.split(src_dir, "/"), vim.split(dest_dir, "/")
  local n = prefix_length(xs, ys)

  local prefix = table.concat(ys, "/", 1, n)
  return vim.fs.joinpath(prefix, ys[n + 1] or "")
end

function M.extension(path)
  local chunks = vim.split(vim.fs.basename(path), ".", { plain = true })
  table.remove(chunks, 1)
  local extension = table.concat(chunks, ".")
  if #extension > 0 then
    extension = "." .. extension
  end
  return extension
end

return M
