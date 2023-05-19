if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

function SetPythonOptions()
  setl tabstop=4 softtabstop=4 shiftwidth=4 expandtab makeprg=pylint

  map <buffer> <leader><CR> :w !python<CR>
  map <buffer> gh :up \| !black % && isort %<CR>
  nmap <buffer> <leader><Tab> :up <CR>n:terminal ipython -i #<CR>

  let b:lsp_start="vim.lsp.start({
  \   name = 'python-lsp',
  \   cmd = {'pylsp'},
  \   cmd_env = { VIRTUAL_ENV = os.getenv('HOME') .. '/.local/share/nvim/lsp_servers/pylsp/venv' },
  \   root_dir = vim.fs.dirname(vim.fs.find({'setup.py', 'pyproject.toml'}, { upward = true })[1])
  \ })"
endfunction

call SetPythonOptions()
