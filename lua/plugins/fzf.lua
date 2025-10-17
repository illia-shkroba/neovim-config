return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  opts = {},
  config = function()
    local fzf = require "fzf-lua"
    local path = require "fzf-lua.path"

    local function remove_file(selected, opts)
      for _, sel in ipairs(selected) do
        local entry = path.entry_to_file(sel, opts)
        local entry_path = entry.bufname or entry.path
        assert(entry_path, "entry doesn't contain filepath")
        if not entry_path then
          return
        end
        pcall(vim.fn.delete, entry_path)
      end
    end

    fzf.setup {
      winopts = {
        on_create = function()
          -- Called once upon creation of the fzf main window.
          vim.keymap.set("t", "<C-r><C-a>", function()
            vim.cmd.buffer "#"
            local word = vim.fn.expand "<cWORD>"
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
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-y"] = fzf.actions.arg_add,
          ["ctrl-z"] = { fn = fzf.actions.buf_del, reload = true },
        },
      },
      diagnostics = {
        actions = {
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      files = {
        actions = {
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
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
          ["ctrl-y"] = fzf.actions.arg_add,
        },
      },
      jumps = {
        actions = {
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      lines = {
        actions = {
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      lsp = {
        workspace_symbols = {
          actions = {
            ["ctrl-s"] = false,
            ["ctrl-x"] = fzf.actions.file_split,
          },
        },
        finder = {
          actions = {
            ["ctrl-s"] = false,
            ["ctrl-x"] = fzf.actions.file_split,
          },
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
      tags = {
        actions = {
          ["ctrl-s"] = false,
          ["ctrl-x"] = fzf.actions.file_split,
        },
      },
      treesitter = {
        actions = {
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
          ["ctrl-s"] = false,
          ["ctrl-t"] = function(selected, opts)
            vim.cmd.tabedit()
            opts.scope = "tab"
            fzf.actions.zoxide_cd(selected, opts)
          end,
        },
      },
    }
  end,
}
