local function create_packer_bootstrap()
  local path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

  local is_installed = string.len(vim.fn.glob(path)) > 0
  if is_installed then
    return function() end
  end

  vim.fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    path,
  }
  vim.cmd [[
    packadd packer.nvim
  ]]

  return require("packer").sync
end

return {
  create_packer_bootstrap = create_packer_bootstrap,
}
