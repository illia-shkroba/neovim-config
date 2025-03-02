return {
  "jvgrootveld/telescope-zoxide",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    local telescope = require "telescope"
    telescope.setup {
      extensions = {
        zoxide = {
          prompt_title = "Zoxide",
          mappings = {
            ["<C-e>"] = {
              action = function(selection)
                vim.cmd.edit(selection.path)
              end,
            },
            ["<C-v>"] = {
              action = function(selection)
                vim.cmd.vsplit(selection.path)
              end,
            },
            ["<C-x>"] = {
              action = function(selection)
                vim.cmd.split(selection.path)
              end,
            },

            default = {
              action = function(selection)
                vim.cmd.cd(selection.path)
              end,
              after_action = function(selection)
                vim.notify("Directory changed to " .. selection.path)
              end,
            },
            ["<C-l>"] = {
              action = function(selection)
                vim.cmd.lcd(selection.path)
              end,
              after_action = function(selection)
                vim.notify("Directory changed for window to " .. selection.path)
              end,
            },
            ["<C-t>"] = {
              action = function(selection)
                vim.cmd.tcd(selection.path)
              end,
              after_action = function(selection)
                vim.notify("Directory changed for tab to " .. selection.path)
              end,
            },
          },
        },
      },
    }
    telescope.load_extension "zoxide"

    vim.keymap.set(
      "n",
      [[<leader>fz]],
      require("telescope").extensions.zoxide.list
    )
  end,
}
