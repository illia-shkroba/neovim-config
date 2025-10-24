local M = {}

local fzf = require "fzf-lua"

local function common_prefix(strings)
  local column_uniques = function(i)
    local result = {}
    for _, x in pairs(strings) do
      local key = x:sub(i, i)
      result[key] = true
    end
    return vim.tbl_keys(result)
  end

  local result = ""
  local i = 1
  while true do
    local uniques = column_uniques(i)
    if #uniques == 1 and #uniques[1] > 0 then
      result = result .. uniques[1]
    else
      return result
    end
    i = i + 1
  end
end

local function find_prefix_of(str, prefix)
  local sub_str = str
  local offset = 0
  while true do
    local begin, _ = sub_str:find(prefix:sub(1, 1), 1, true)
    if begin == nil then
      return nil
    end
    offset = offset + begin

    local suffix = sub_str:sub(begin)
    if suffix == prefix:sub(1, #suffix) then
      return offset - 1
    else
      sub_str = sub_str:sub(begin + 1)
    end
  end
end

local remove_inserted = function(completions, buffer, cursor)
  -- The `common_prefix` is used to find a common prefix for a list of
  -- completions. Then the text on the left side of the current cursor position
  -- is matched for the common prefix that was found. If the text "partially"
  -- matches the common prefix (see `find_prefix_of`), then the text is assumed
  -- to be "inserted" by the user before triggering the completion.
  local prefix = common_prefix(completions)
  local line, column_end = cursor[1], cursor[2] + 1
  local column_begin = math.max(column_end - #prefix, 0)

  local lines = vim.api.nvim_buf_get_text(
    buffer,
    line - 1,
    column_begin,
    line - 1,
    column_end,
    {}
  )

  local offset = find_prefix_of(lines[1], prefix)
  if offset ~= nil and #prefix > 0 then
    local remove_column = column_begin + offset
    vim.api.nvim_buf_set_text(
      buffer,
      line - 1,
      remove_column,
      line - 1,
      column_end,
      {}
    )
    return { column = remove_column }
  else
    return nil
  end
end

local paste_completion = function(
  selected,
  completions,
  completed_buffer,
  cursor
)
  local removed_location =
    remove_inserted(completions, completed_buffer, cursor)
  if removed_location ~= nil then
    -- Shift the cursor one character after the inserted text.
    local line = cursor[1]
    vim.api.nvim_win_set_cursor(
      vim.api.nvim_get_current_win(),
      { line, removed_location.column }
    )
  end

  -- The cursor captured in the insert mode is positioned one character after
  -- the inserted text.
  vim.api.nvim_put({ selected[1] }, "c", false, true)
end

-- It should only be used when: `vim.fn.pumvisible() == 1`.
M.completion = function(prioritize_init)
  local completions = vim.tbl_map(function(x)
    return x.word
  end, vim.fn.complete_info({ "items" }).items)
  local completed_buffer = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())

  local line, column = cursor[1], cursor[2]
  -- In the insert mode the cursor's column is shifted by one character to the
  -- right if the cursor has no characters before it.
  --
  -- Meaning, that when the cursor is at the beginning of the line, the
  -- `column` is 0. Otherwise, it is a `column` a position (index +1) and not
  -- an index.
  column = math.max(column - 1, 0)
  cursor = { line, column }

  local paste_completion_action = function(selected)
    paste_completion(selected, completions, completed_buffer, cursor)
  end

  fzf.fzf_exec(completions, {
    winopts = {
      title = " Completions ",
    },
    actions = {
      ["enter"] = paste_completion_action,
      ["ctrl-y"] = paste_completion_action,
      ["ctrl-e"] = fzf.actions.dummy_abort,
    },
    fzf_opts = {
      ["--no-multi"] = true,
      ["--tac"] = not prioritize_init,
    },
  })
end

-- To be called in `vim.keymap.set` with `expr = true`. It should only be used
-- when: `vim.fn.pumvisible() == 1`.
M.completion_expr = function(opts)
  opts = vim.tbl_deep_extend(
    "keep",
    opts or {},
    { popup_menu_up_key = [[<C-p>]], popup_menu_down_key = [[<C-n>]] }
  )

  local info = vim.fn.complete_info { "items", "selected" }
  local expr
  local prioritize_init
  if info.selected < #info.items / 2 then
    expr = string.rep(opts.popup_menu_up_key, info.selected + 1)
    prioritize_init = true
  else
    expr = string.rep(opts.popup_menu_down_key, #info.items - info.selected)
    prioritize_init = false
  end

  vim.schedule(function()
    M.completion(prioritize_init)
  end)

  return expr
end

return M
