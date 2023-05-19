if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function SetTerraformOptions()
  setl tabstop=2 softtabstop=2 shiftwidth=2 expandtab

  lua << EOF
  function vim.b.lsp_start()
    vim.lsp.start {
      name = "terraform-lsp",
      cmd = { "terraform-ls", "serve" },
    }
  end
EOF
endfunction

call SetTerraformOptions()
