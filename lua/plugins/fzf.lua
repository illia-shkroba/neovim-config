local utils = require "utils"

return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  config = function()
    local fzf = require "fzf-lua"
    local fzf_defaults = (require "fzf-lua.defaults").defaults
    local win = require "fzf-lua.win"
    local path = require "fzf-lua.path"
    local pickers = require "plugins.fzf.pickers"
    local register = require "text.register"
    local scratch_register = require "scratch.register"
    local window = require "window"

    local function args(selected, opts)
      utils.try(vim.cmd, [[argdelete *]])
      fzf.actions.arg_add(selected, opts)
    end

    local function remove_file(selected, opts)
      for _, sel in ipairs(selected) do
        local entry = path.entry_to_file(sel, opts)
        local entry_path = entry.bufname or entry.path
        assert(entry_path, "entry doesn't contain filepath")
        pcall(vim.fs.rm, entry_path)
      end
    end

    -- Windows of a tab that get an entry in the `tabs` picker list.
    local function displayed_windows(tabh)
      return vim.tbl_filter(function(window_)
        local buffer = vim.api.nvim_win_get_buf(window_)
        return vim.fn.buflisted(buffer) == 1
          and vim.api.nvim_buf_is_loaded(buffer)
      end, vim.api.nvim_tabpage_list_wins(tabh))
    end

    -- Position of a tab's topmost window entry in the `tabs` picker list.
    local function tab_position(target)
      local position = 0
      for tabnr, tabh in ipairs(vim.api.nvim_list_tabpages()) do
        local windows = displayed_windows(tabh)

        if tabnr == target then
          return position + (#windows > 0 and 2 or 1)
        end

        -- (+1) to skip title entries.
        position = position + 1 + #windows
      end

      return position
    end

    local function edit_register(selected)
      if #selected == 0 then
        return
      end

      -- `registers` entries are prefixed with "[<register>] [<regtype>] ".
      local register_ = selected[1]:match "%[(.-)%]"
      if register_ then
        scratch_register.edit(register_)
      end
    end

    local function close_tabs(selected, opts)
      local topmost_closed
      for _, sel in ipairs(selected) do
        -- `tabs` entries are prefixed with "<tabnr>\t<tabh>\t<winid>)".
        local tabh = tonumber(sel:match "(%d+)\t%d+%)")

        if tabh and vim.api.nvim_tabpage_is_valid(tabh) then
          local tabnr = vim.api.nvim_tabpage_get_number(tabh)

          utils.try(vim.cmd.tabclose, tabnr)

          -- `tabclose` may fail, e.g. on a modified buffer with `nohidden`, so
          -- track only the tabs that are actually gone.
          if
            not vim.api.nvim_tabpage_is_valid(tabh)
            and (not topmost_closed or tabnr < topmost_closed)
          then
            topmost_closed = tabnr
          end
        end
      end

      -- `tabs` picker keeps the cursor on `__locate_pos`, which is set on picker
      -- start to the current tab, on reload point it at the tab that took the
      -- place of the topmost closed one instead.
      if topmost_closed then
        local tabnr = math.min(topmost_closed, #vim.api.nvim_list_tabpages())
        opts.__locate_pos = tab_position(tabnr)
      end
    end

    fzf.setup {
      defaults = {
        actions = {
          ["alt-n"] = pickers.yank,
          ["ctrl-s"] = false,
        },
      },
      keymap = {
        fzf = {
          ["alt-a"] = win.toggle_fullscreen,
          ["alt-s"] = win.toggle_preview,
        },
      },
      winopts = {
        on_create = function()
          -- Called once upon creation of the fzf main window.
          vim.keymap.set("t", "<C-r>", function()
            return [[<C-\><C-N>"]] .. vim.fn.getcharstr() .. [[pi]]
          end, { expr = true, buffer = true })
          vim.keymap.set("t", "<C-r><C-a>", function()
            vim.cmd.buffer "#"
            local word = vim.fn.expand "<cWORD>"
            vim.cmd.buffer "#"

            vim.api.nvim_feedkeys(word, "n", true)
          end, { buffer = true })
          vim.keymap.set("t", "<C-r><C-l>", function()
            vim.cmd.buffer "#"
            local word = vim.fn.getline "."
            vim.cmd.buffer "#"

            vim.api.nvim_feedkeys(word, "n", true)
          end, { buffer = true })
          vim.keymap.set("t", "<C-r><C-p>", function()
            vim.cmd.buffer "#"
            local word = vim.fn.expand "<cfile>"
            vim.cmd.buffer "#"

            vim.api.nvim_feedkeys(word, "n", true)
          end, { buffer = true })
          vim.keymap.set("t", "<C-r><C-w>", function()
            vim.cmd.buffer "#"
            local word = vim.fn.expand "<cword>"
            vim.cmd.buffer "#"

            vim.api.nvim_feedkeys(word, "n", true)
          end, { buffer = true })
        end,
      },
      args = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-z"] = { fn = fzf.actions.arg_del, reload = true },
        },
      },
      blines = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      buffers = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-y"] = args,
          ["ctrl-z"] = { fn = fzf.actions.buf_del, reload = true },
          ["ctrl-alt-y"] = fzf.actions.arg_add,
        },
      },
      changes = {
        actions = {
          ["ctrl-v"] = function(selected, opts)
            vim.cmd.vsplit()
            fzf.actions.goto_jump(selected, opts)
          end,
          ["ctrl-x"] = function(selected, opts)
            vim.cmd.split()
            fzf.actions.goto_jump(selected, opts)
          end,
        },
      },
      command_history = {
        actions = {
          ["ctrl-e"] = false,
          ["ctrl-f"] = fzf.actions.ex_run,
          ["ctrl-x"] = false,
          ["ctrl-z"] = {
            fn = fzf.actions.ex_del,
            field_index = "{+n}",
            reload = true,
          },
        },
      },
      diagnostics = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      files = {
        actions = {
          ["alt-t"] = function(_, opts)
            local cwd_only = not opts.__cwd_only
            opts.__call_fn(vim.tbl_deep_extend("keep", {
              __cwd_only = cwd_only,
              resume = true,
              winopts = {
                title = cwd_only and " Files (cwd) " or " Files ",
              },
              find_opts = (cwd_only and [[-maxdepth 1 ]] or "")
                .. fzf_defaults.files.find_opts,
              fd_opts = (cwd_only and [[--max-depth 1 ]] or "")
                .. fzf_defaults.files.fd_opts,
            }, opts.__call_opts or {}))
          end,
          ["alt-f"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-y"] = args,
          ["ctrl-z"] = {
            fn = remove_file,
            reload = true,
          },
          ["ctrl-alt-y"] = fzf.actions.arg_add,
        },
      },
      filetypes = {
        actions = {
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      git = {
        bcommits = {
          actions = {
            ["ctrl-x"] = fzf.actions.git_buf_split,
          },
        },
      },
      grep = {
        actions = {
          ["alt-f"] = false,
          ["alt-y"] = function(_, opts)
            local args_ = vim
              .iter(vim.fn.argv())
              :map(function(arg)
                return vim.fs.abspath(vim.fs.normalize(arg))
              end)
              :totable()

            opts.__call_fn(vim.tbl_extend("keep", {
              search_paths = args_,
              resume = true, -- keeps current query
            }, opts.__call_opts or {}))
          end,
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-y"] = args,
          ["ctrl-alt-y"] = fzf.actions.arg_add,
        },
      },
      jumps = {
        actions = {
          ["ctrl-v"] = function(selected, opts)
            vim.cmd.vsplit()
            fzf.actions.goto_jump(selected, opts)
          end,
          ["ctrl-x"] = function(selected, opts)
            vim.cmd.split()
            fzf.actions.goto_jump(selected, opts)
          end,
        },
      },
      lines = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      loclist = {
        actions = {
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-z"] = { fn = fzf.actions.list_del, reload = true },
        },
      },
      loclist_stack = {
        actions = {
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      lsp = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
        workspace_symbols = {
          actions = {
            ["alt-f"] = false,
            ["ctrl-x"] = fzf.actions.file_split,
          },
        },
        finder = {
          actions = {
            ["alt-f"] = false,
            ["ctrl-x"] = fzf.actions.file_split,
          },
        },
      },
      manpages = {
        actions = {
          ["ctrl-x"] = fzf.actions.man,
        },
      },
      marks = {
        actions = {
          ["ctrl-x"] = fzf.actions.goto_mark_split,
          ["ctrl-z"] = { fn = fzf.actions.mark_del, reload = true },
        },
      },
      oldfiles = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-y"] = args,
          ["ctrl-z"] = {
            fn = remove_file,
            reload = true,
          },
          ["ctrl-alt-y"] = fzf.actions.arg_add,
        },
      },
      quickfix = {
        actions = {
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-z"] = { fn = fzf.actions.list_del, reload = true },
        },
      },
      quickfix_stack = {
        actions = {
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      registers = {
        actions = {
          ["enter"] = edit_register,
          ["ctrl-t"] = function(selected)
            edit_register(selected)
            vim.cmd.wincmd "T"
          end,
          ["ctrl-v"] = function(selected)
            edit_register(selected)
            window.to_vertical(vim.api.nvim_get_current_win())
          end,
          ["ctrl-x"] = edit_register,
        },
      },
      search_history = {
        actions = {
          ["enter"] = function(selected)
            if not selected[1] then
              return
            end
            register.put("/", { selected[1] })
          end,
          ["ctrl-e"] = false,
          ["ctrl-f"] = fzf.actions.search,
          ["ctrl-x"] = false,
          ["ctrl-z"] = {
            fn = fzf.actions.search_del,
            field_index = "{+n}",
            reload = true,
          },
        },
      },
      tabs = {
        actions = {
          ["alt-f"] = false,
          ["alt-z"] = { fn = close_tabs, reload = true },
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-z"] = { fn = fzf.actions.buf_del, reload = true },
        },
      },
      tags = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      tagstack = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      treesitter = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      zoxide = {
        actions = pickers.directories_actions,
      },
    }
  end,
}
