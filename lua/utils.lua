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

return M
