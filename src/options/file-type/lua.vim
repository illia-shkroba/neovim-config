function SetLuaOptions()
  map <buffer> <leader>c :w !lua <CR>
  nmap <buffer> <leader>C :up <CR>n:terminal lua -i # <CR>
  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab formatprg=stylua\ --\ -

  let b:lsp_start="vim.lsp.start({
  \   name = 'lua-lsp',
  \   cmd = {'lua-language-server'}
  \ })"
  call LSPCallback()
endfunction
