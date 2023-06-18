local M = {}

local cmd = vim.cmd
local fn = vim.fn

local utils = require "utils"

function M.normal()
  local quote = fn.getcharstr()
  local motion = utils.read_motion { allow_forced = false }

  cmd.normal("v" .. motion.count .. motion.motion .. M.quote(quote))
end

function M.visual()
  cmd.normal(M.quote(fn.getcharstr()))
end

function M.quote(quote)
  return [[`>a]] .. quote .. [[`<i]] .. quote .. [[]]
end

return M
