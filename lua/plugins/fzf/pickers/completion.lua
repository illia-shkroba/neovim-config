local M = {}

local fzf = require "fzf-lua"
local region = require "text.region"

-- The `cursor_begin` is where the text replaced by the completion begins, as
-- captured by `completion_expr`.
---@param cursor_begin table<integer, integer>
---@param prioritize_init boolean
---@return nil
function M.completion(cursor_begin, prioritize_init)
  local line_begin, column_begin = cursor_begin[1], cursor_begin[2]

  local completions = vim
    .iter(vim.fn.complete_info({ "items", "matches" }).items)
    :filter(function(item)
      return item.match
    end)
    :map(function(item)
      return item.word
    end)
    :totable()

  local window = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(window)
  local column = cursor[2]

  local completed_region = region.from {
    buffer_number = vim.api.nvim_get_current_buf(),
    line_begin = line_begin,
    column_begin = column_begin,
    line_end = line_begin,
    column_end = column - 1,
    type_ = "char",
  }

  local function paste(text)
    local pasted_region = region.substitute(completed_region, { text })

    vim.api.nvim_win_set_cursor(
      window,
      { pasted_region.line_end, math.max(pasted_region.column_end, 0) }
    )
  end

  local function paste_completion(selected)
    paste(selected[1])
  end

  local function append_query(_, opts)
    paste(completed_region.lines[1] .. (opts.last_query or ""))
  end

  fzf.fzf_exec(completions, {
    winopts = {
      title = " Completions ",
      relative = "cursor",
      row = 1,
      col = 0,
      height = 0.40,
      width = 0.30,
    },
    actions = {
      ["enter"] = paste_completion,
      ["ctrl-y"] = paste_completion,
      ["ctrl-i"] = append_query,
      ["ctrl-e"] = fzf.actions.dummy_abort,
    },
    fzf_opts = {
      ["--no-multi"] = true,
      ["--tiebreak"] = "length,end,index",
      ["--tac"] = not prioritize_init,
    },
  })
end

-- Called in `vim.keymap.set` with `expr = true` on `vim.fn.pumvisible() == 1`.
---@param opts? { popup_menu_down_key: string, popup_menu_up_key: string }
---@return string
function M.completion_expr(opts)
  opts = vim.tbl_deep_extend(
    "keep",
    opts or {},
    { popup_menu_up_key = [[<C-p>]], popup_menu_down_key = [[<C-n>]] }
  )

  local info = vim.fn.complete_info { "items", "selected" }
  if info.selected < 0 then
    vim.notify(
      "No popup-menu item is selected, so the text the completion replaces "
        .. "cannot be located. Select an item first.",
      vim.log.levels.WARN
    )
    return ""
  end

  -- The popup menu is still live while an `expr = true` mapping is being
  -- evaluated, so the buffer holds the selected item's `word` ending exactly
  -- at the cursor, and the completion begins at `column - #word`.
  local cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
  local line, column = cursor[1], cursor[2]
  local word = info.items[info.selected + 1].word
  local cursor_begin = { line, math.max(column - #word, 0) }

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
    M.completion(cursor_begin, prioritize_init)
  end)

  return expr
end

return M
