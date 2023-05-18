if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function SetLuaOptions()
  map <buffer> <leader>c :w !lua <CR>
  nmap <buffer> <leader>C :up <CR>n:terminal lua -i # <CR>
  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  setl formatprg=stylua\ --call-parentheses=none\ --column-width=80\ --indent-type=spaces\ --indent-width=2\ --\ -

  let b:lsp_start="vim.lsp.start({
  \   name = 'lua-lsp',
  \   cmd = {'lua-language-server'}
  \ })"
endfunction

call SetLuaOptions()
