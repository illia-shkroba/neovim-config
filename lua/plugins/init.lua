vim.cmd [[
  packadd cfilter
]]

local packer_bootstrap = require("plugins.bootstrap").create_packer_bootstrap()

return require("packer").startup(function(use)
  use "wbthomason/packer.nvim"

  use { "LnL7/vim-nix", ft = { "nix" } }
  use {
    "folke/tokyonight.nvim",
    branch = "main",
    config = function()
      local tokyonight = require("utils").require_safe "tokyonight"
      if tokyonight then
        tokyonight.setup {
          style = "moon",
          transparent = true,
          terminal_colors = true,
          dim_inactive = true,
        }

        vim.cmd [[
          colorscheme tokyonight-moon
          highlight clear LineNr
        ]]
      end

      vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "gray", bold = true })
      vim.api.nvim_set_hl(0, "LineNr", { fg = "white", bold = true })
      vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "gray", bold = true })
    end,
  }
  use {
    "nvim-telescope/telescope.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
      local actions = require("utils").require_safe "telescope.actions"
      if not actions then
        return
      end

      local telescope = require "plugins.telescope"
      local union = require("utils").union

      local global_mappings = {
        n = {
          ["<C-c>"] = actions.close,
          ["<C-d>"] = actions.results_scrolling_down,
          ["<C-e>"] = actions.smart_add_to_qflist + actions.open_qflist,
          ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          ["<C-u>"] = actions.results_scrolling_up,
          ["d"] = actions.preview_scrolling_down,
          ["u"] = actions.preview_scrolling_up,
        },
        i = {
          ["<C-d>"] = actions.results_scrolling_down,
          ["<C-e>"] = actions.smart_add_to_qflist + actions.open_qflist,
          ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
          ["<C-u>"] = actions.results_scrolling_up,
        },
      }
      local find_files_mappings = {
        n = {
          ["<C-h>"] = telescope.toggle_hidden_in_find_files,
        },
        i = {
          ["<C-h>"] = telescope.toggle_hidden_in_find_files,
        },
      }
      require("telescope").setup {
        pickers = {
          buffers = { mappings = global_mappings },
          colorscheme = { mappings = global_mappings },
          find_files = {
            mappings = union(find_files_mappings, global_mappings),
          },
          live_grep = { mappings = global_mappings },
          marks = { mappings = global_mappings },
          oldfiles = { mappings = global_mappings },
          spell_suggest = { mappings = global_mappings },
          tags = { mappings = global_mappings },
        },
      }
    end,
  }
  use {
    "nvim-tree/nvim-tree.lua",
    requires = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- disable netrw
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1

      require "plugins.setup" "nvim-tree"()
    end,
  }
  use { "pearofducks/ansible-vim", ft = { "yaml" } }
  use {
    "purescript-contrib/purescript-vim",
    config = function()
      vim.g.purescript_unicode_conceal_enable = 0
    end,
    ft = { "purescript" },
  }
  use "tpope/vim-fugitive"

  packer_bootstrap()
end)
