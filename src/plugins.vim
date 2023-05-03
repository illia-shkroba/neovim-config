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

function s:EnableNvimTree()
  " disable netrw
  lua vim.g.loaded_netrw = 1
  lua vim.g.loaded_netrwPlugin = 1

  lua require("nvim-tree").setup()
endfunction

function s:EnablePureScript()
  let g:purescript_unicode_conceal_enable = 0
endfunction

function s:EnableColorscheme()
  lua require("tokyonight").setup({
  \   style = "moon",
  \   transparent = true,
  \   terminal_colors = true,
  \   dim_inactive = true
  \ })

  colorscheme tokyonight-moon
  highlight clear LineNr

  lua vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='gray',  bold=true })
  lua vim.api.nvim_set_hl(0, 'LineNr',      { fg='white', bold=true })
  lua vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='gray',  bold=true })
endfunction

call s:EnableNvimTree()
call s:EnablePureScript()
call s:EnableColorscheme()

delfunction s:EnableNvimTree
delfunction s:EnablePureScript
delfunction s:EnableColorscheme
