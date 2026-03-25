local M = {}

---@param register string
---@return string
function M.normalize(register)
  local r = register:lower()
  return ({
    ["!"] = "1",
    ["@"] = "2",
    ["#"] = "3",
    ["$"] = "4",
    ["%"] = "5",
    ["^"] = "6",
    ["&"] = "7",
    ["*"] = "8",
    ["("] = "9",
    [")"] = "0",
    ["?"] = "/",
  })[r] or r
end

return M
