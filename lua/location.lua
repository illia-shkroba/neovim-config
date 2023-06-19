local M = {}

local cmd = vim.cmd

function M.search(text)
  cmd.lvimgrep(text, "##")
  return text
end

return M
