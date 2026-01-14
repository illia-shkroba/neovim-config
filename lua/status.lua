-- Search status. Returns one of:
-- * "f" - most recent search was a forward search.
-- * "b" - most recent search was a backward search.
local function get_search_status()
  return [[v:searchforward ? 'f' : 'b']]
end

-- Current working directory in a concise format.
local function get_cwd()
  return [[substitute(getcwd(0, 0), '^' .. expand('~'), '~', '')]]
end

local function get_statusline()
  return "%<%f %h%m%r"
    .. ("|%{" .. get_search_status() .. "}| ")
    .. ("(%{" .. get_cwd() .. "})")
    .. "%=%-14.(%l,%c%V%) %P"
end

return {
  statusline = get_statusline(),
}
