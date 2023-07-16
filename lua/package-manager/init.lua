vim.cmd [[
  packadd cfilter
]]

require("package-manager.bootstrap").bootstrap()

return require("lazy").setup("plugins", {
  change_detection = {
    enabled = false,
  },
})
