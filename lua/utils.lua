local M = {}

function M.require_safe(module_name)
  return M.try(require, module_name)
end

function M.try(f, ...)
  local status, result = pcall(f, ...)
  if status then
    return result
  else
    return nil
  end
end

function M.union(first, last)
  if type(first) == "table" and type(last) == "table" then
    return M.union_tables(first, last)
  else
    return first
  end
end

function M.union_tables(first, last)
  local dest = M.deepcopy(first)
  for k, v2 in pairs(last) do
    local v1 = dest[k]
    if v1 == nil then
      dest[k] = M.deepcopy(v2)
    else
      dest[k] = M.union(v1, v2)
    end
  end
  return dest
end

function M.deepcopy(src)
  if type(src) ~= "table" then
    return src
  end

  local dest = {}
  for k, v in pairs(src) do
    dest[M.deepcopy(k)] = M.deepcopy(v)
  end
  return dest
end

function M.split(xs, sep)
  local parts = {}

  local begin, end_ = 1, 0
  local i = 1
  while i <= #xs do
    local ys = xs:sub(i, i + #sep - 1)
    if ys == sep then
      table.insert(parts, xs:sub(begin, end_))

      i = i + #sep
      begin = i
      end_ = begin - 1
    else
      i = i + 1
      end_ = end_ + 1
    end
  end

  table.insert(parts, xs:sub(begin, end_))

  return parts
end

function M.prefix_length(xs, ys)
  local n = M.min(#xs, #ys)
  for i = 1, n do
    local x, y = xs[i], ys[i]

    if x ~= y then
      return i - 1
    end
  end
  return n
end

function M.min(x, y)
  if x <= y then
    return x
  else
    return y
  end
end

function M.max(x, y)
  if x >= y then
    return x
  else
    return y
  end
end

return M
