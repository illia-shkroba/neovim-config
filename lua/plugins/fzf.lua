return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  config = function()
    local fzf = require "fzf-lua"
    local win = require "fzf-lua.win"
    local path = require "fzf-lua.path"

    local function remove_file(selected, opts)
      for _, sel in ipairs(selected) do
        local entry = path.entry_to_file(sel, opts)
        local entry_path = entry.bufname or entry.path
        assert(entry_path, "entry doesn't contain filepath")
        if not entry_path then
          return
        end
        pcall(vim.fs.rm, entry_path)
      end
    end

    fzf.setup {
      keymap = {
        fzf = {
          ["alt-a"] = win.toggle_fullscreen,
          ["alt-s"] = win.toggle_preview,
          ["ctrl-q"] = "select-all+accept",
        },
      },
      winopts = {
        on_create = function()
          -- Called once upon creation of the fzf main window.
          vim.keymap.set("t", "<C-r>", function()
            return [[<C-\><C-N>"]] .. vim.fn.getcharstr() .. [[pi]]
          end, { expr = true, silent = true, buffer = true })
          vim.keymap.set("t", "<C-r><C-a>", function()
            vim.cmd.buffer "#"
            local word = vim.fn.expand "<cWORD>"
            vim.cmd.buffer "#"

            vim.api.nvim_feedkeys(word, "n", true)
          end, { silent = true, buffer = true })
          vim.keymap.set("t", "<C-r><C-l>", function()
            vim.cmd.buffer "#"
            local word = vim.fn.getline "."
            vim.cmd.buffer "#"

            vim.api.nvim_feedkeys(word, "n", true)
          end, { silent = true, buffer = true })
          vim.keymap.set("t", "<C-r><C-p>", function()
            vim.cmd.buffer "#"
            local word = vim.fn.expand "<cfile>"
            vim.cmd.buffer "#"

            vim.api.nvim_feedkeys(word, "n", true)
          end, { silent = true, buffer = true })
          vim.keymap.set("t", "<C-r><C-w>", function()
            vim.cmd.buffer "#"
            local word = vim.fn.expand "<cword>"
            vim.cmd.buffer "#"

            vim.api.nvim_feedkeys(word, "n", true)
          end, { silent = true, buffer = true })
        end,
      },
      blines = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      btags = {
        actions = {
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      buffers = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-y"] = fzf.actions.arg_add,
          ["ctrl-z"] = { fn = fzf.actions.buf_del, reload = true },
        },
      },
      command_history = {
        actions = {
          ["ctrl-e"] = false,
          ["ctrl-v"] = fzf.actions.ex_run,
        },
      },
      diagnostics = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      files = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-y"] = fzf.actions.arg_add,
          ["ctrl-z"] = {
            fn = remove_file,
            reload = true,
          },
        },
      },
      filetypes = {
        actions = {
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      git = {
        bcommits = {
          actions = {
            ["ctrl-s"] = false,
            ["ctrl-x"] = fzf.actions.git_buf_split,
          },
        },
      },
      grep = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-y"] = fzf.actions.arg_add,
        },
      },
      jumps = {
        actions = {
          ["ctrl-s"] = false,
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
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      lsp = {
        workspace_symbols = {
          actions = {
            ["alt-f"] = false,
            ["ctrl-s"] = false,
            ["ctrl-x"] = fzf.actions.file_split,
          },
        },
        finder = {
          actions = {
            ["alt-f"] = false,
            ["ctrl-s"] = false,
            ["ctrl-x"] = fzf.actions.file_split,
          },
        },
      },
      manpages = {
        actions = {
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.man,
        },
      },
      marks = {
        actions = {
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.goto_mark_split,
          ["ctrl-z"] = { fn = fzf.actions.mark_del, reload = true },
        },
      },
      oldfiles = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-y"] = fzf.actions.arg_add,
          ["ctrl-z"] = {
            fn = remove_file,
            reload = true,
          },
        },
      },
      quickfix = {
        actions = {
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-z"] = { fn = fzf.actions.list_del, reload = true },
        },
      },
      quickfix_stack = {
        actions = {
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      tabs = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-z"] = { fn = fzf.actions.buf_del, reload = true },
        },
      },
      tags = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      treesitter = {
        actions = {
          ["alt-f"] = false,
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      zoxide = {
        actions = {
          ["enter"] = function(selected, opts)
            opts.scope = "tab"
            fzf.actions.zoxide_cd(selected, opts)
          end,
          ["ctrl-f"] = function(selected)
            if #selected == 0 then
              return
            end
            local cwd = selected[1]:match "[^\t]+$" or selected[1]

            fzf.files { cwd = cwd }
          end,
          ["ctrl-s"] = false,
          ["ctrl-t"] = function(selected, opts)
            vim.cmd.tabedit()
            opts.scope = "tab"
            fzf.actions.zoxide_cd(selected, opts)
          end,
          ["ctrl-v"] = function(selected, opts)
            vim.cmd.vnew()
            opts.scope = "local"
            fzf.actions.zoxide_cd(selected, opts)
          end,
          ["ctrl-x"] = function(selected, opts)
            vim.cmd.new()
            opts.scope = "local"
            fzf.actions.zoxide_cd(selected, opts)
          end,
        },
      },
    }
  end,
}
