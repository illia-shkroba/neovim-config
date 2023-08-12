return {
  "neoclide/coc.nvim",
  init = function()
    local fn = vim.fn

    vim.g.coc_config_home = fn.stdpath "config" .. "/etc/coc"
    vim.g.coc_data_home = fn.stdpath "data" .. "/coc"
    vim.g.coc_filetype_map = {
      ["yaml.ansible"] = "ansible",
    }
    vim.g.coc_global_extensions = {
      "@yaegassy/coc-ansible",
      "coc-docker",
      "coc-git",
      "coc-json",
      "coc-lua",
      "coc-pyright",
      "coc-vimlsp",
    }
  end,
  config = function()
    local augroup = vim.api.nvim_create_augroup
    local autocmd = vim.api.nvim_create_autocmd
    local cmd = vim.cmd
    local command = vim.api.nvim_create_user_command
    local fn = vim.fn
    local opt = vim.opt
    local set = vim.keymap.set

    -- Some servers have issues with backup files
    opt.backup = false
    opt.writebackup = false

    -- Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
    -- delays and poor user experience
    opt.updatetime = 300

    -- Always show the signcolumn, otherwise it would shift the text each time
    -- diagnostics appeared/became resolved
    opt.signcolumn = "yes"

    -- Autocomplete
    local function check_back_space()
      local col = fn.col "." - 1
      return col == 0 or fn.getline("."):sub(col, col):match "%s" ~= nil
    end

    -- Use Tab for trigger completion with characters ahead and navigate
    -- NOTE: There's always a completion item selected by default, you may want to enable
    -- no select by setting `"suggest.noselect": true` in your configuration file
    set(
      "i",
      [[<TAB>]],
      function()
        if fn["coc#pum#visible"]() == 1 then
          return fn["coc#pum#next"](1)
        elseif check_back_space() then
          return [[	]]
        else
          return fn["coc#refresh"]()
        end
      end,
      { silent = true, noremap = true, expr = true, replace_keycodes = false }
    )
    set(
      "i",
      [[<S-TAB>]],
      function()
        if fn["coc#pum#visible"]() == 1 then
          return fn["coc#pum#prev"](1)
        else
          return [[	]]
        end
      end,
      { silent = true, noremap = true, expr = true, replace_keycodes = false }
    )
    set(
      "i",
      [[<CR>]],
      [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<C-r>=coc#on_enter()\<CR>"]],
      { silent = true, noremap = true, expr = true, replace_keycodes = false }
    )

    -- Use <C-j> to trigger snippets
    set("i", [[<C-j>]], [[<Plug>(coc-snippets-expand-jump)]])
    -- Use <C-space> to trigger completion
    set("i", [[<C-space>]], fn["coc#refresh"], { silent = true, expr = true })

    -- Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
    set("n", "]e", [[<Plug>(coc-diagnostic-next)]], { silent = true })
    set("n", "[e", [[<Plug>(coc-diagnostic-prev)]], { silent = true })

    -- GoTo code navigation
    set("n", [[<leader>gD]], [[<Plug>(coc-definition)]], { silent = true })
    set("n", [[<leader>gd<C-t>]], [[sTgD]], { silent = true })
    set("n", [[<leader>gd<C-v>]], [[vgD]], { silent = true })
    set("n", [[<leader>gd<C-x>]], [[sgD]], { silent = true })
    set("n", [[<leader>gi]], [[<Plug>(coc-implementation)]], { silent = true })
    set("n", [[<leader>gr]], [[<Plug>(coc-references)]], { silent = true })
    set("n", [[<leader>gy]], [[<Plug>(coc-type-definition)]], { silent = true })

    -- Use K to show documentation in preview window
    local function show_docs()
      local cw = fn.expand "<cword>"
      if vim.tbl_contains({ "vim", "help" }, vim.bo.filetype) then
        cmd("h " .. cw)
      elseif fn["coc#rpc#ready"]() == 1 then
        fn.CocActionAsync "doHover"
      else
        cmd("!" .. vim.o.keywordprg .. " " .. cw)
      end
    end
    set("n", [[K]], show_docs, { silent = true })

    -- Highlight the symbol and its references on a CursorHold event(cursor is idle)
    augroup("CocGroup", {})
    autocmd("CursorHold", {
      group = "CocGroup",
      command = "silent call CocActionAsync('highlight')",
      desc = "Highlight symbol under cursor on CursorHold",
    })

    -- Symbol renaming
    set("n", [[<leader>cN]], [[<Plug>(coc-rename)]], { silent = true })

    -- Apply codeAction to the selected region
    -- Example: `<leader>aap` for current paragraph
    set(
      "",
      [[<leader>a]],
      [[<Plug>(coc-codeaction-selected)]],
      { silent = true, nowait = true }
    )

    -- Remap keys for apply code actions at the cursor position.
    set(
      "n",
      [[<leader>.]],
      [[<Plug>(coc-codeaction-cursor)]],
      { silent = true, nowait = true }
    )
    -- Remap keys for apply source code actions for current file.
    set(
      "n",
      [[<leader>as]],
      [[<Plug>(coc-codeaction-source)]],
      { silent = true, nowait = true }
    )
    -- Apply the most preferred quickfix action on the current line.
    set(
      "n",
      [[<leader>qf]],
      [[<Plug>(coc-fix-current)]],
      { silent = true, nowait = true }
    )

    -- Remap keys for apply refactor code actions.
    set(
      "n",
      [[<leader>re]],
      [[<Plug>(coc-codeaction-refactor)]],
      { silent = true }
    )
    set(
      "",
      [[<leader>r]],
      [[<Plug>(coc-codeaction-refactor-selected)]],
      { silent = true }
    )

    -- Run the Code Lens actions on the current line
    set(
      "n",
      [[<leader>cl]],
      [[<Plug>(coc-codelens-action)]],
      { silent = true, nowait = true }
    )

    -- Map function and class text objects
    set(
      "x",
      [[if]],
      [[<Plug>(coc-funcobj-i)]],
      { silent = true, nowait = true }
    )
    set(
      "o",
      [[if]],
      [[<Plug>(coc-funcobj-i)]],
      { silent = true, nowait = true }
    )

    set(
      "x",
      [[af]],
      [[<Plug>(coc-funcobj-a)]],
      { silent = true, nowait = true }
    )
    set(
      "o",
      [[af]],
      [[<Plug>(coc-funcobj-a)]],
      { silent = true, nowait = true }
    )

    set(
      "x",
      [[ic]],
      [[<Plug>(coc-classobj-i)]],
      { silent = true, nowait = true }
    )
    set(
      "o",
      [[ic]],
      [[<Plug>(coc-classobj-i)]],
      { silent = true, nowait = true }
    )

    set(
      "x",
      [[ac]],
      [[<Plug>(coc-classobj-a)]],
      { silent = true, nowait = true }
    )
    set(
      "o",
      [[ac]],
      [[<Plug>(coc-classobj-a)]],
      { silent = true, nowait = true }
    )

    -- Use CTRL-S for selections ranges
    -- Requires 'textDocument/selectionRange' support of language server
    set("", [[<C-s>]], [[<Plug>(coc-range-select)]], { silent = true })

    -- Add `:Format` command to format current buffer
    command("Format", function()
      fn.CocAction "format"
    end, {})

    -- " Add `:Fold` command to fold current buffer
    command("Fold", [[call CocAction('fold', <f-args>)]], { nargs = "?" })

    -- Add `:OR` command for organize imports of the current buffer
    command("OR", function()
      fn.CocActionAsync("runCommand", "editor.action.organizeImport")
    end, {})

    -- Show all diagnostics
    set("n", [[<leader>A]], function()
      cmd.CocList "diagnostics"
    end, { silent = true, nowait = true })
    -- Search workspace symbols
    set("n", [[<leader>fw]], function()
      cmd.CocList("-I", "symbols")
    end, { silent = true, nowait = true })
    -- Do default action for next item
    set("n", [[<leader>j]], cmd.CocNext, { silent = true, nowait = true })
    -- Do default action for previous item
    set("n", [[<leader>k]], cmd.CocPrev, { silent = true, nowait = true })
    -- Resume latest coc list
    set("n", [[<leader>p]], cmd.CocListResume, { silent = true, nowait = true })
  end,
  branch = "release",
}
