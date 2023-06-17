local M = {}

local cmd = vim.cmd
local fn = vim.fn

local utils = require "utils"

function M.normal()
  local quote = fn.getcharstr()
  local result = utils.read_number()
  local count, text_object = result.number, result.rest

  if vim.tbl_contains({ "i", "a" }, text_object) then
    text_object = text_object .. fn.getcharstr()
  end

  local string_count
  if count == 0 then
    string_count = ""
  else
    string_count = tostring(count)
  end

  cmd.normal("v" .. string_count .. text_object .. M.quote(quote))
end

function M.visual()
  cmd.normal(M.quote(fn.getcharstr()))
end

function M.quote(quote)
  return [[`>a]] .. quote .. [[`<i]] .. quote .. [[]]
end

return M
