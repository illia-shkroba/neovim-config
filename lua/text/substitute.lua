local M = {}

local cmd = vim.cmd
local fn = vim.fn

local utils = require "utils"

function M.substitute_char_prompt(xs)
  vim.print "Enter target char: "
  local target = utils.try(fn.getcharstr)
  if not target then
    return nil
  end

  cmd.redraw()

  vim.print "Enter substitution char: "
  local substitution = utils.try(fn.getcharstr)
  if not substitution then
    return nil
  end

  -- For some reason `substitution` has "kb" when hitting backspace and
  -- converted to `128` with `fn.char2nr`, but fn.nr2char(128) is "". Thus,
  -- `substitution == fn.nr2char(128)` is `false`.
  local backspace_number = 128 -- kb
  if substitution == "" or fn.char2nr(substitution) == backspace_number then
    substitution = ""
  end

  local read_newline = fn.nr2char(13) -- ^M
  local insertable_newline = fn.nr2char(10) -- \r
  if substitution == read_newline then
    substitution = insertable_newline
  end

  return M.substitute_char(xs, target, substitution)
end

function M.substitute_char(xs, target, substitution)
  local acc = ""

  local i = 1
  while i <= #xs do
    local char = xs:sub(i, i)
    local new_char = char == target and substitution or char

    i = i + 1
    acc = acc .. new_char
  end

  return acc
end

return M
