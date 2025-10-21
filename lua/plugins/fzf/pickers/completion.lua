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

local function ends_with_prefix_of(str, prefix)
  assert(
    #str <= #prefix,
    "length of string that ends with prefix (left) should be "
      .. "less than or equal to length of string containing prefix (right)"
  )
  local sub_str = str
  local offset = 0
  while true do
    local begin, _ = sub_str:find(prefix:sub(1, 1), 1, true)
    if begin == nil then
      return nil
    end

    local suffix = sub_str:sub(begin)
    if suffix == prefix:sub(1, #suffix) then
      return begin + offset
    else
      sub_str = sub_str:sub(begin + 1)
      offset = offset + begin
    end
  end
end

local substitute_inserted = function(completions, buffer, cursor)
  -- The `common_prefix` is used to find a common prefix for a list of
  -- completions. Then the text on the left side of the current cursor position
  -- is matched for the common prefix that was found. If the text "partially"
  -- matches the common prefix (see `ends_with_prefix_of`), then the text is
  -- assumed to be "inserted" by the user before triggering the completion.
  local prefix = common_prefix(completions)
  local line, column_end = cursor[1], cursor[2]
  local column_begin = column_end - #prefix
  if column_begin < 0 then
    column_begin = 0
  end

  local lines = vim.api.nvim_buf_get_text(
    buffer,
    line - 1,
    column_begin,
    line - 1,
    column_end,
    {}
  )

  if #prefix > 0 and #lines > 0 then
    local offset = ends_with_prefix_of(lines[1], prefix)
    if offset ~= nil then
      local insert_column = column_begin + offset - 1
      vim.api.nvim_buf_set_text(
        buffer,
        line - 1,
        insert_column,
        line - 1,
        column_end,
        {}
      )
      return { column = insert_column }
    end
  end
  return nil
end

local paste_completion = function(
  selected,
  completions,
  completed_buffer,
  cursor
)
  local line, column = cursor[1], cursor[2]
  local lines =
    vim.api.nvim_buf_get_lines(completed_buffer, line - 1, line, true)
  local cursor_at_end_of_line = (column + 1) >= #lines[#lines]

  local insert_location = substitute_inserted(
    completions,
    completed_buffer,
    cursor
  ) or { column = column }

  -- Shift the cursor to its original position.
  vim.cmd.normal(tostring(insert_location.column + 1) .. "|")

  vim.api.nvim_put({ selected[1] }, "c", cursor_at_end_of_line, true)
end

-- It should only be used when: `vim.fn.pumvisible() == 1`.
M.completion = function()
  local completions = vim.tbl_map(function(x)
    return x.word
  end, vim.fn.complete_info({ "items" }).items)
  local completed_buffer = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())

  local paste_completion_action = function(selected)
    paste_completion(selected, completions, completed_buffer, cursor)
  end

  vim.schedule(function()
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
      },
    })
  end)
end

-- To be called in `vim.keymap.set` with `expr = true`. It should only be used
-- when: `vim.fn.pumvisible() == 1`.
M.completion_expr = function(opts)
  opts = vim.tbl_deep_extend(
    "keep",
    opts or {},
    { popup_menu_up_key = [[<C-p>]], popup_menu_down_key = [[<C-n>]] }
  )

  vim.schedule(M.completion)

  local info = vim.fn.complete_info { "items", "selected" }
  if info.selected < #info.items / 2 then
    return string.rep(opts.popup_menu_up_key, info.selected + 1)
  else
    return string.rep(opts.popup_menu_down_key, #info.items - info.selected)
  end
end

return M
