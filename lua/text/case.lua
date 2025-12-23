local M = {}

---@param region Region
---@return string
function M.to_camel(region)
  local xs = table.concat(region.lines, "\n")

  local acc = ""

  local i = 1
  while i <= #xs do
    local x = xs:sub(i, i)

    if x == "_" then
      i = i + 1
      x = xs:sub(i, i):upper()
    end

    i = i + 1
    acc = acc .. x
  end

  return acc
end

---@param region Region
---@return string
function M.to_snake(region)
  local xs = table.concat(region.lines, "\n")

  local acc = ""

  local i = 1
  while i <= #xs do
    local x = xs:sub(i, i)

    -- match uppercase letters
    if x:match "%u" then
      x = "_" .. x:lower()
    end

    i = i + 1
    acc = acc .. x
  end

  return acc
end

return M
