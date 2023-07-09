vim.cmd [[
  packadd cfilter
]]

require("package-manager.bootstrap").bootstrap()

return require("lazy").setup "plugins"
