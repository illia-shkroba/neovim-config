return {
  "illia-shkroba/telescope-zoxide",
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
                vim.cmd.tcd(selection.path)
              end,
              after_action = function(selection)
                vim.notify(
                  "Directory changed for current tab to: " .. selection.path,
                  vim.log.levels.INFO
                )
              end,
            },
            ["<C-t>"] = {
              action = function(selection)
                vim.cmd.tabedit()
                vim.cmd.tcd(selection.path)
              end,
              after_action = function(selection)
                vim.notify(
                  "Directory changed for tab to: " .. selection.path,
                  vim.log.levels.INFO
                )
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
