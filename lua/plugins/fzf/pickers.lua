local M = {}

local fzf = require "fzf-lua"
local path = require "fzf-lua.path"
local utils = require "fzf-lua.utils"
local filetypes = require "filetypes"

---@param picker any
---@param search string|nil
---@param matching_filetypes table<integer, string>|nil
---@param query string|nil
---@return nil
local function grep_by_filetype(picker, search, matching_filetypes, query)
  if matching_filetypes == nil then
    local filetype = vim.opt_local.filetype._value
    local filename = vim.fs.basename(vim.api.nvim_buf_get_name(0))

    matching_filetypes = filetypes.match_rg(filetype, filename)
  end

  local actions = {
    ["alt-t"] = function()
      M.rg_filetypes {
        winopts = {
          title = search and " Filetypes Grep (" .. search .. ") "
            or " Filetypes Grep ",
        },
        actions = {
          ["enter"] = function(selected, opts)
            grep_by_filetype(picker, search, selected, opts.__INFO.last_query)
          end,
        },
      }
    end,
  }

  if #matching_filetypes == 0 or vim.tbl_contains(matching_filetypes, "") then
    picker {
      actions = actions,
      silent = true,
      search = search,
      query = query,
    }
  else
    local type_options = {}

    for _, sel in ipairs(matching_filetypes) do
      table.insert(type_options, "--type=" .. sel)
    end

    picker {
      winopts = {
        title = " Grep (" .. table.concat(matching_filetypes, ", ") .. ") ",
      },
      actions = actions,
      silent = true,
      search = search,
      query = query,
      rg_opts = table.concat(type_options, " ")
        .. " --column --line-number --no-heading --color=always --smart-case"
        .. " --max-columns=4096 -e",
    }
  end
end

---@param opts table<string, any>|nil
---@return nil
function M.rg_filetypes(opts)
  opts = opts or {}
  opts.winopts = opts.winopts ~= nil and opts.winopts
    or {
      title = " Filetypes Grep ",
    }

  local all_filetypes = vim.tbl_keys(filetypes.rg_to_patterns)
  -- "" file type resembles "no file type".
  table.insert(all_filetypes, 1, "")
  fzf.fzf_exec(all_filetypes, opts)
end

---@param region Region
---@param matching_filetypes table<integer, string>|nil
---@return nil
function M.grep_by_filetype(region, matching_filetypes)
  grep_by_filetype(
    fzf.grep,
    table.concat(region.lines, "\n"),
    matching_filetypes
  )
end

---@param matching_filetypes table<integer, string>|nil
---@return nil
function M.live_grep_by_filetype(matching_filetypes)
  grep_by_filetype(fzf.live_grep, nil, matching_filetypes)
end

---@param matching_filetypes table<integer, string>|nil
---@return nil
function M.grep_cword_by_filetype(matching_filetypes)
  grep_by_filetype(fzf.grep_cword, nil, matching_filetypes)
end

---@class DirectoriesInput
---@field cwd string|nil

---@param directories_input DirectoriesInput|nil
---@return nil
function M.directories(directories_input)
  directories_input = directories_input or {}

  fzf.files {
    cwd = directories_input.cwd,
    winopts = {
      title = " Directories ",
    },
    actions = vim.tbl_deep_extend("keep", {
      ["alt-t"] = function()
        M.directories_cwd(directories_input)
      end,
    }, M.directories_actions),
    find_opts = [[-type d \! -path '*/.git/*']],
    fd_opts = [[--color=never --type d --exclude .git]],
  }
end

---@param directories_input DirectoriesInput|nil
---@return nil
function M.directories_cwd(directories_input)
  directories_input = directories_input or {}

  fzf.files {
    cwd = directories_input.cwd,
    winopts = {
      title = " Directories (cwd) ",
    },
    actions = vim.tbl_deep_extend("keep", {
      ["alt-t"] = function()
        M.directories(directories_input)
      end,
    }, M.directories_actions),
    find_opts = [[-maxdepth 1 -type d \! -path '*/.git/*']],
    fd_opts = [[--max-depth 1 --color=never --type d --exclude .git]],
  }
end

---@param e string
---@return string
local function absolute_path_from_entry(e)
  return path.entry_to_file(e:match "[^\t]+$" or e, { cwd = utils.cwd() }).path
end

M.directories_actions = {
  ["enter"] = function(selected, opts)
    if #selected == 0 then
      return
    end
    opts.scope = "tab"
    fzf.actions.zoxide_cd({ absolute_path_from_entry(selected[1]) }, opts)
  end,
  ["ctrl-f"] = function(selected)
    if #selected == 0 then
      return
    end
    fzf.files { cwd = absolute_path_from_entry(selected[1]) }
  end,
  ["ctrl-s"] = false,
  ["ctrl-t"] = function(selected, opts)
    if #selected == 0 then
      return
    end
    vim.cmd.tabedit()
    opts.scope = "tab"
    fzf.actions.zoxide_cd({ absolute_path_from_entry(selected[1]) }, opts)
  end,
  ["ctrl-v"] = function(selected, opts)
    if #selected == 0 then
      return
    end
    vim.cmd.vnew()
    opts.scope = "local"
    fzf.actions.zoxide_cd({ absolute_path_from_entry(selected[1]) }, opts)
  end,
  ["ctrl-x"] = function(selected, opts)
    if #selected == 0 then
      return
    end
    vim.cmd.new()
    opts.scope = "local"
    fzf.actions.zoxide_cd({ absolute_path_from_entry(selected[1]) }, opts)
  end,
}

return M
