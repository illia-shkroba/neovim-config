let g:lsp_enabled = 0

function StartLSP()
  if exists("b:lsp_start")
    execute "lua " .. b:lsp_start
  endif
endfunction

function StopLSP()
  lua vim.lsp.stop_client(vim.lsp.get_active_clients())
endfunction

function EnableLSP()
  let g:lsp_enabled = 1
  set omnifunc=v:lua.vim.lsp.omnifunc
  call StartLSP()
endfunction

function DisableLSP()
  let g:lsp_enabled = 0
  set omnifunc=syntaxcomplete#Complete
  call StopLSP()
endfunction

function LSPCallback()
  if g:lsp_enabled
    call StartLSP()
  endif
endfunction
