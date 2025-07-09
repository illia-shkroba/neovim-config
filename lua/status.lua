-- Search status. Returns one of:
-- * "f" - most recent search was a forward search.
-- * "b" - most recent search was a backward search.
local function get_search_status()
  return [[v:searchforward ? 'f' : 'b']]
end

-- Char search status. Returns one of:
-- * "F*" - `F` motion was used along with a character denoted as '*'.
-- * "T*" - `T` motion was used along with a character denoted as '*'.
-- * "f*" - `f` motion was used along with a character denoted as '*'.
-- * "t*" - `t` motion was used along with a character denoted as '*'.
-- * "-" - no char search was performed yet.
local function get_char_search_status()
  return [[getcharsearch().char == '' ? '-' : ((getcharsearch().forward ? (getcharsearch().until ? 't' : 'f') : (getcharsearch().until ? 'T' : 'F')) .. getcharsearch().char)]]
end

-- Current working directory in a concise format.
local function get_cwd()
  return [[substitute(getcwd(0, 0), '^' .. expand('~'), '~', '')]]
end

local function get_statusline()
  local char_search = get_char_search_status()

  return "%<%f %h%m%r"
    .. ("|%{" .. get_search_status() .. "}| ")
    .. (char_search and ("<%{" .. char_search .. "}> ") or "")
    .. ("(%{" .. get_cwd() .. "})")
    .. "%=%-14.(%l,%c%V%) %P"
end

return {
  statusline = get_statusline(),
}
