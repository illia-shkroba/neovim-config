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

local function glob(path, pattern)
  return vim.glob.to_lpeg(pattern):match(path) ~= nil
end

local function match_rg(nvim_filetype, path)
  local rg_matches = M.nvim_to_rg[nvim_filetype]
  if rg_matches == nil then
    return {}
  end

  if #rg_matches == 1 or path == nil then
    return rg_matches
  end

  return vim.tbl_filter(function(rg_match)
    for _, pattern in pairs(rg_match.filenames) do
      if glob(path, pattern) then
        return true
      end
    end
    return false
  end, rg_matches)
end

function M.match_rg(nvim_filetype, path)
  return vim.tbl_map(function(x)
    return x.rg_type
  end, match_rg(nvim_filetype, path))
end

return M
