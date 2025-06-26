local M = {}

function M.bootstrap()
  local path = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
  if not vim.loop.fs_stat(path) then
    vim.fn.system {
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
