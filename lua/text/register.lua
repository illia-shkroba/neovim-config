local M = {}

local utils = require "utils"

---@return nil
function M.normalized_expr()
  local raw_register = utils.try(vim.fn.getcharstr)
  if not raw_register then
    return
  end

  local register = M.normalize(raw_register)
  return [["]] .. register
end

---@param register string
---@return string
function M.normalize(register)
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
  })[register] or register
end

return M
