local M = {}

local fn = vim.fn

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

function M.read_motion(options)
  local allow_forced
  if type(options) == "table" and type(options.allow_forced) == "boolean" then
    allow_forced = options.allow_forced
  else
    allow_forced = true
  end

  local result = M.read_number()
  local count, acc = result.number, result.rest

  local last = acc
  if allow_forced and vim.tbl_contains({ "v", "V", "" }, last) then
    last = fn.getcharstr()
    acc = acc .. last
  end

  if
    vim.tbl_contains({ "i", "a", "f", "F", "t", "T", "[", "]", "'", "`" }, last)
  then
    acc = acc .. fn.getcharstr()
  elseif vim.tbl_contains({ "g" }, last) then
    last = fn.getcharstr()
    acc = acc .. last
    if vim.tbl_contains({ "'", "`" }, last) then
      acc = acc .. fn.getcharstr()
    end
  end

  local string_count
  if count == 0 then
    string_count = ""
  else
    string_count = tostring(count)
  end

  return {
    count = string_count,
    motion = acc,
  }
end

function M.read_number()
  local lower, upper = fn.char2nr "0", fn.char2nr "9"

  local acc = 0
  local char = fn.getchar()
  while lower <= char and char <= upper do
    acc = acc * 10 + char - lower
    char = fn.getchar()
  end

  return {
    number = acc,
    rest = fn.nr2char(char),
  }
end

return M
