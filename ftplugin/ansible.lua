if vim.b.did_ansible_ftplugin then
  return
end
vim.b.did_ansible_ftplugin = true

function vim.b.lsp_start()
  vim.lsp.start {
    name = "ansible-lsp",
    cmd = { "ansible-language-server", "--stdio" },
  }
end
