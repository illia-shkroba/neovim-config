local M = {}

local utils = require "utils"

---@param region Region
---@return string
function M.substitute_prompt(region)
  vim.print "Enter target char: "
  local target = utils.try(vim.fn.getcharstr)
  if not target then
    vim.notify("No target provided to `substitute`.", vim.log.levels.INFO)
    return table.concat(region.lines, "\n")
  end

  vim.cmd.redraw()

  vim.print "Enter substitution char: "
  local substitution = utils.try(vim.fn.getcharstr)
  if not substitution then
    vim.notify("No substitution provided to `substitute`.", vim.log.levels.INFO)
    return table.concat(region.lines, "\n")
  end

  -- For some reason `substitution` has "kb" when hitting backspace and
  -- converted to `128` with `vim.fn.char2nr`, but vim.fn.nr2char(128) is "". Thus,
  -- `substitution == vim.fn.nr2char(128)` is `false`.
  local backspace_number = 128 -- kb
  if
    substitution == "" or vim.fn.char2nr(substitution) == backspace_number
  then
    substitution = ""
  end

  local read_newline = vim.fn.nr2char(13) -- ^M
  local insertable_newline = vim.fn.nr2char(10) -- \r
  if target == read_newline then
    target = insertable_newline
  end
  if substitution == read_newline then
    substitution = insertable_newline
  end

  return M.substitute(region, target, substitution)
end

---@param region Region
---@param target string
---@param substitution string
---@return string
function M.substitute(region, target, substitution)
  local xs = table.concat(region.lines, "\n")

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

---@param region Region
---@return string
function M.prepend_prompt(region)
  vim.print "Enter target char: "
  local target = utils.try(vim.fn.getcharstr)
  if not target then
    vim.notify("No target provided to `prepend`.", vim.log.levels.INFO)
    return table.concat(region.lines, "\n")
  end

  vim.cmd.redraw()

  vim.print "Enter prefix char: "
  local prefix = utils.try(vim.fn.getcharstr)
  if not prefix then
    vim.notify("No prefix provided to `prepend`.", vim.log.levels.INFO)
    return table.concat(region.lines, "\n")
  end

  -- For some reason `prefix` has "kb" when hitting backspace and
  -- converted to `128` with `vim.fn.char2nr`, but vim.fn.nr2char(128) is "". Thus,
  -- `prefix == vim.fn.nr2char(128)` is `false`.
  local backspace_number = 128 -- kb
  if prefix == "" or vim.fn.char2nr(prefix) == backspace_number then
    return table.concat(region.lines, "\n")
  end

  local read_newline = vim.fn.nr2char(13) -- ^M
  local insertable_newline = vim.fn.nr2char(10) -- \r
  if target == read_newline then
    target = insertable_newline
  end
  if prefix == read_newline then
    prefix = insertable_newline
  end

  return M.prepend(region, target, prefix)
end

---@param region Region
---@param target string
---@param prefix string
---@return string
function M.prepend(region, target, prefix)
  local xs = table.concat(region.lines, "\n")

  local acc = ""

  local i = 1
  while i <= #xs do
    local char = xs:sub(i, i)
    local new_chars = char == target and prefix .. char or char

    i = i + 1
    acc = acc .. new_chars
  end

  return acc
end

---@param region Region
---@return string
function M.append_prompt(region)
  vim.print "Enter target char: "
  local target = utils.try(vim.fn.getcharstr)
  if not target then
    vim.notify("No target provided to `append`.", vim.log.levels.INFO)
    return table.concat(region.lines, "\n")
  end

  vim.cmd.redraw()

  vim.print "Enter suffix char: "
  local suffix = utils.try(vim.fn.getcharstr)
  if not suffix then
    vim.notify("No suffix provided to `append`.", vim.log.levels.INFO)
    return table.concat(region.lines, "\n")
  end

  -- For some reason `suffix` has "kb" when hitting backspace and
  -- converted to `128` with `vim.fn.char2nr`, but vim.fn.nr2char(128) is "". Thus,
  -- `suffix == vim.fn.nr2char(128)` is `false`.
  local backspace_number = 128 -- kb
  if suffix == "" or vim.fn.char2nr(suffix) == backspace_number then
    return table.concat(region.lines, "\n")
  end

  local read_newline = vim.fn.nr2char(13) -- ^M
  local insertable_newline = vim.fn.nr2char(10) -- \r
  if target == read_newline then
    target = insertable_newline
  end
  if suffix == read_newline then
    suffix = insertable_newline
  end

  return M.append(region, target, suffix)
end

---@param region Region
---@param target string
---@param suffix string
---@return string
function M.append(region, target, suffix)
  local xs = table.concat(region.lines, "\n")

  local acc = ""

  local i = 1
  while i <= #xs do
    local char = xs:sub(i, i)
    local new_chars = char == target and char .. suffix or char

    i = i + 1
    acc = acc .. new_chars
  end

  return acc
end

return M
