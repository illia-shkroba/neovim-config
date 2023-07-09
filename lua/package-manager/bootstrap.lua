local M = {}

local fn = vim.fn
local loop = vim.loop

function M.bootstrap()
  local path = fn.stdpath "data" .. "/lazy/lazy.nvim"
  if not loop.fs_stat(path) then
    fn.system {
      "git",
      "clone",
      "--branch=stable", -- latest stable release
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      path,
    }
  end
  vim.opt.rtp:prepend(path)
end

return M
