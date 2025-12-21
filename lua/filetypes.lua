local M = {}

local config = vim.fn.stdpath "config"

local function read(path)
  local handle = io.open(path)

  if handle == nil then
    vim.notify(
      "Unable to read `"
        .. path
        .. "` file. Run `"
        .. vim.fs.joinpath(config, "etc", "filetypes", "gen.sh")
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

M.nvim_to_rg =
  read(vim.fs.joinpath(config, "etc", "filetypes", "nvim-to-rg.json"))
M.rg = read(vim.fs.joinpath(config, "etc", "filetypes", "rg.json"))

local function glob(filename, pattern)
  return vim.glob.to_lpeg(pattern):match(filename) ~= nil
end

local function match_rg(nvim_filetype, filename)
  local rg_matches = M.nvim_to_rg[nvim_filetype]
  if rg_matches == nil then
    return {}
  end

  if #rg_matches == 1 or filename == nil then
    return rg_matches
  end

  return vim.tbl_filter(function(rg_match)
    for _, pattern in pairs(rg_match.filenames) do
      if glob(filename, pattern) then
        return true
      end
    end
    return false
  end, rg_matches)
end

function M.match_rg(nvim_filetype, filename)
  return vim.tbl_map(function(x)
    return x.rg_type
  end, match_rg(nvim_filetype, filename))
end

return M
