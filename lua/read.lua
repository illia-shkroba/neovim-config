local M = {}

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
    last = vim.fn.getcharstr()
    acc = acc .. last
  end

  if
    vim.tbl_contains({ "i", "a", "f", "F", "t", "T", "[", "]", "'", "`" }, last)
  then
    acc = acc .. vim.fn.getcharstr()
  elseif vim.tbl_contains({ "g" }, last) then
    last = vim.fn.getcharstr()
    acc = acc .. last
    if vim.tbl_contains({ "'", "`" }, last) then
      acc = acc .. vim.fn.getcharstr()
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
  local lower, upper = vim.fn.char2nr "0", vim.fn.char2nr "9"

  local acc = 0
  local char = vim.fn.getchar()
  while lower <= char and char <= upper do
    acc = acc * 10 + char - lower
    char = vim.fn.getchar()
  end

  return {
    number = acc,
    rest = vim.fn.nr2char(char),
  }
end

return M
