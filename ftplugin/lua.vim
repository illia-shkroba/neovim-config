if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function SetLuaOptions()
  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  setl formatprg=stylua\ --call-parentheses=none\ --column-width=80\ --indent-type=spaces\ --indent-width=2\ --\ -

  map <buffer> <leader><CR> :w !lua<CR>
  nmap <buffer> <leader><Tab> :up <CR>n:terminal lua -i #<CR>

  lua << EOF
  function vim.b.lsp_start()
    vim.lsp.start {
      name = "lua-lsp",
      cmd = { "lua-language-server" },
    }
  end
EOF
endfunction

call SetLuaOptions()
