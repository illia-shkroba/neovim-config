if vim.b.did_python_ftplugin then
  return
end
vim.b.did_python_ftplugin = true

local api = vim.api
local cmd = vim.cmd
local fn = vim.fn
local fs = vim.fs
local loop = vim.loop
local opt_local = vim.opt_local
local set = vim.keymap.set

opt_local.expandtab = true
opt_local.makeprg = "pylint"
opt_local.shiftwidth = 4
opt_local.softtabstop = 4
opt_local.tabstop = 4

local function find_virtual_environment()
  return fs.find({ "env", "venv", ".env", ".venv" }, {
    path = api.nvim_buf_get_name(0),
    upward = true,
    stop = loop.os_homedir(),
    type = "directory",
  })[1]
end

set("", [[gh]], [[<Cmd>up | !black % && isort %<CR>]], { buffer = true })
set("n", [[<leader><CR>]], function()
  local virtual_environment = find_virtual_environment()

  local variables
  if virtual_environment then
    variables = "PATH='"
      .. virtual_environment
      .. "/bin:"
      .. fn.getenv "PATH"
      .. "' "
  else
    variables = ""
  end

  cmd.update()
  cmd.new()

  cmd.terminal(variables .. "sh -c 'python #'")
  cmd.startinsert()
end, { buffer = true })
set("n", [[<leader><Tab>]], function()
  local virtual_environment = find_virtual_environment()

  local variables
  if virtual_environment then
    variables = "VIRTUAL_ENV='" .. virtual_environment .. "' "
  else
    variables = ""
  end

  cmd.update()
  cmd.new()

  cmd.terminal(variables .. "ipython --no-banner -i '#'")
  cmd.startinsert()
end, { buffer = true })
