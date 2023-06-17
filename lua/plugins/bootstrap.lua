local M = {}

local cmd = vim.cmd
local fn = vim.fn

function M.create_packer_bootstrap()
  local path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

  local is_installed = #fn.glob(path) > 0
  if is_installed then
    return function() end
  end

  fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    path,
  }
  cmd [[
    packadd packer.nvim
  ]]

  return require("packer").sync
end

return M
