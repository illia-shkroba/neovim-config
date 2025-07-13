vim.cmd [[
  packadd cfilter
]]

-- Bootstrap
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
vim.opt.runtimepath:prepend(path)

return require("lazy").setup("plugins", {
  root = vim.fn.stdpath "data" .. "/lazy", -- directory where plugins will be installed
  lockfile = vim.fn.stdpath "config" .. "/lazy-lock.json", -- lockfile generated after running update.
  change_detection = {
    enabled = false,
  },
})
