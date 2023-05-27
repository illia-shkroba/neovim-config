if vim.b.did_python_ftplugin then
  return
end
vim.b.did_python_ftplugin = true

local api = vim.api
local fs = vim.fs
local loop = vim.loop
local opt_local = vim.opt_local
local set = vim.keymap.set

opt_local.expandtab = true
opt_local.makeprg = "pylint"
opt_local.shiftwidth = 4
opt_local.softtabstop = 4
opt_local.tabstop = 4

set("", [[<leader><CR>]], [[<Cmd>w !python<CR>]], { buffer = true })
set("", [[gh]], [[<Cmd>up | !black % && isort %<CR>]], { buffer = true })
set("n", [[<leader><Tab>]], [[<Cmd>up<CR>:new<CR>:terminal ipython -i #<CR>]], { buffer = true })

function vim.b.lsp_start()
  vim.lsp.start {
    name = "python-lsp",
    cmd = { "pylsp" },
    cmd_env = {
      VIRTUAL_ENV = fs.find({ "venv" }, {
        path = api.nvim_buf_get_name(0),
        upward = true,
        stop = loop.os_homedir(),
        type = "directory",
      })[1],
    },
    root_dir = fs.find({ "setup.py", "pyproject.toml" }, {
      path = api.nvim_buf_get_name(0),
      upward = true,
      stop = loop.os_homedir(),
      type = "file",
    })[1],
  }
end
