if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function SetShellScriptOptions()
  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab makeprg=shellcheck

  execute "setl formatprg=shfmt\\ -s\\ -i\\ " .. &tabstop .. "\\ -bn\\ -ci\\ -sr"

  map <buffer> <leader><CR> :w !bash<CR>
  nmap <buffer> <leader><Tab> :up <CR>n:terminal bash --init-file #<CR>
endfunction

call SetShellScriptOptions()
