packadd cfilter

call plug#begin()
Plug 'LnL7/vim-nix'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'nvim-lua/plenary.nvim' " dependency for telescope
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons' " icons used by nvim-tree
Plug 'pearofducks/ansible-vim'
Plug 'purescript-contrib/purescript-vim'
Plug 'tpope/vim-fugitive'
call plug#end()

function s:EnableColorscheme()
  lua require("tokyonight").setup({
  \   style = "moon",
  \   transparent = true,
  \   terminal_colors = true,
  \   dim_inactive = true
  \ })

  colorscheme tokyonight-moon
  highlight clear LineNr

  lua vim.api.nvim_set_hl(0, "LineNrAbove", { fg="gray",  bold=true })
  lua vim.api.nvim_set_hl(0, "LineNr",      { fg="white", bold=true })
  lua vim.api.nvim_set_hl(0, "LineNrBelow", { fg="gray",  bold=true })
endfunction

function s:EnableNvimTree()
  " disable netrw
  lua vim.g.loaded_netrw = 1
  lua vim.g.loaded_netrwPlugin = 1

  lua require("nvim-tree").setup()
endfunction

function s:EnablePureScript()
  let g:purescript_unicode_conceal_enable = 0
endfunction

function s:EnableTelescope()
lua << EOF
  local mappings = {
    mappings = {
      n = {
        ["<C-c>"] = "close",
        ["<C-d>"] = "results_scrolling_down",
        ["<C-u>"] = "results_scrolling_up",
        ["d"] = "preview_scrolling_down",
        ["u"] = "preview_scrolling_up",
      },
      i = {
        ["<C-d>"] = "results_scrolling_down",
        ["<C-u>"] = "results_scrolling_up",
      }
    }
  }
  require("telescope").setup {
    pickers = {
      buffers = mappings,
      colorscheme = mappings,
      find_files = mappings,
      live_grep = mappings,
      marks = mappings,
      oldfiles = mappings,
      spell_suggest = mappings,
      tags = mappings,
    }
  }
EOF
endfunction

call s:EnableColorscheme()
call s:EnableNvimTree()
call s:EnablePureScript()
call s:EnableTelescope()

delfunction s:EnableColorscheme
delfunction s:EnableNvimTree
delfunction s:EnablePureScript
delfunction s:EnableTelescope
