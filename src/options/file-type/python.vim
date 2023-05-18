function SetPythonOptions()
  map <buffer> <leader>c :w !python <CR>
  nmap <buffer> <leader>C :up <CR>n:terminal ipython -i # <CR>
  map <buffer> gh :up \| !black % && isort % <CR>
  nmap <leader>ii yiwggofrom itertools import p
  nmap <leader>in yiwggofrom nonion import p
  setl tabstop=4 softtabstop=4 shiftwidth=4 expandtab makeprg=pylint

  let b:lsp_start="vim.lsp.start({
  \   name = 'python-lsp',
  \   cmd = {'pylsp'},
  \   cmd_env = { VIRTUAL_ENV = os.getenv('HOME') .. '/.local/share/nvim/lsp_servers/pylsp/venv' },
  \   root_dir = vim.fs.dirname(vim.fs.find({'setup.py', 'pyproject.toml'}, { upward = true })[1])
  \ })"
endfunction
