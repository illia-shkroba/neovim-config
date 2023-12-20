local M = {}

function M.to_camel(xs)
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

function M.to_snake(xs)
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
