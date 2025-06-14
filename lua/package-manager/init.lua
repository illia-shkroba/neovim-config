vim.cmd [[
  packadd cfilter
]]

require("package-manager.bootstrap").bootstrap()

return require("lazy").setup("plugins", {
  root = vim.fn.stdpath "data" .. "/lazy", -- directory where plugins will be installed
  lockfile = vim.fn.stdpath "config" .. "/lazy-lock.json", -- lockfile generated after running update.
  change_detection = {
    enabled = false,
  },
})
