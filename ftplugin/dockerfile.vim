if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function SetDockerfileOptions()
  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab makeprg=hadolint

  lua << EOF
  function vim.b.lsp_start()
    vim.lsp.start {
      name = "docker-lsp",
      cmd = { "docker-langserver", "--stdio" },
    }
  end
EOF
endfunction

call SetDockerfileOptions()
