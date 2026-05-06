local M = {}

local neoclip_storage = require "neoclip.storage"
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

---@param register string
---@param lines table<integer, string>
---@return nil
function M.put(register, lines)
  vim.fn.setreg(register, table.concat(lines, "\n"))

  if register == "/" then
    vim.opt.hlsearch = true
  end

  -- `neoclip` must be invoked directly. It relies on `TextYankPost` and
  -- `vim.v.event`. Although `nvim_exec_autocmds` allows triggering
  -- `TextYankPost`, the `vim.v.event` is readonly.
  if register == '"' then
    neoclip_storage.insert({
      regtype = #lines > 1 and "V" or "v",
      contents = lines,
      filetype = vim.bo.filetype,
    }, "yanks")
  end

  vim.notify([[Changed register "]] .. register, vim.log.levels.INFO)
end

return M
