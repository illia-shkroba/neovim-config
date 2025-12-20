local M = {}

local config = vim.fn.stdpath "config"

local function read(path)
  local handle = io.open(path)

  if handle == nil then
    vim.notify(
      "Unable to read `"
        .. path
        .. "` file. Run `"
        .. config
        .. "/etc/filetypes/gen.sh"
        .. "` script.",
      vim.log.levels.ERROR
    )
    return nil
  end

  local raw_contents = handle:read "*a"
  local contents = vim.json.decode(raw_contents)

  handle:close()

  return contents
end

M.nvim_to_rg = read(config .. "/etc/filetypes/nvim-to-rg.json")
M.rg = read(config .. "/etc/filetypes/rg.json")

return M
