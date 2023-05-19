if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function SetNixOptions()
  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab formatprg=nixfmt

  map <buffer> <leader><CR> :up \| !nix-instantiate --eval --strict %<CR>

  lua << EOF
  function vim.b.lsp_start()
    vim.lsp.start {
      name = "nix-lsp",
      cmd = { "rnix-lsp" },
    }
  end
EOF
endfunction

call SetNixOptions()
