local M = {}

local fzf = require "fzf-lua"
local filetypes = require "filetypes"

local function grep_by_filetype(picker, search, matching_filetypes)
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
          ["enter"] = function(selected)
            grep_by_filetype(picker, search, selected)
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
      rg_opts = table.concat(type_options, " ")
        .. " --column --line-number --no-heading --color=always --smart-case"
        .. " --max-columns=4096 -e",
    }
  end
end

function M.rg_filetypes(opts)
  opts = opts or {}
  opts.winopts = opts.winopts ~= nil and opts.winopts
    or {
      title = " Filetypes Grep ",
    }

  local all_filetypes = vim.deepcopy(filetypes.rg)
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

return M
