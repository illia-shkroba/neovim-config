local utils = require "utils"

-- Search status. Returns one of:
-- * "f" - most recent search was a forward search.
-- * "b" - most recent search was a backward search.
local function get_search_status()
  return [[v:searchforward ? 'f' : 'b']]
end

-- Treesitter status. Returns one of:
-- * "f" - either `f` or `t` motion was used.
-- * "b" - either `F` or `T` motion was used.
-- * "-" - none of the `f`, `t`, `F`, `T` motions was used.
local function get_ts_status()
  local ts_repeat_move =
    utils.require_safe "nvim-treesitter.textobjects.repeatable_move"
  if ts_repeat_move == nil then
    return nil
  end

  return [[luaeval("require('nvim-treesitter.textobjects.repeatable_move').last_move == nil") ? '-' : luaeval("require('nvim-treesitter.textobjects.repeatable_move').last_move.opts.forward") ? 'f' : 'b']]
end

-- Current working directory in a concise format.
local function get_cwd()
  return [[substitute(getcwd(0, 0), '^' .. expand('~'), '~', '')]]
end

local function get_statusline()
  local ts_status = get_ts_status()

  return "%<%f %h%m%r"
    .. ("|%{" .. get_search_status() .. "}| ")
    .. (ts_status and ("<%{" .. ts_status .. "}> ") or "")
    .. ("(%{" .. get_cwd() .. "})")
    .. "%=%-14.(%l,%c%V%) %P"
end

return {
  statusline = get_statusline(),
}
