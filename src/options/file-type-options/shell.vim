function SetShellScriptOptions()
  map <buffer> <leader>c :w !bash <CR>
  nmap <buffer> <leader>C :up <CR>n:terminal bash --init-file # <CR>
  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab formatprg=shfmt\ -s\ -bn\ -ci\ -sr makeprg=shellcheck
endfunction
