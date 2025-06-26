if vim.b.did_python_ftplugin then
  return
end
vim.b.did_python_ftplugin = true

vim.opt_local.expandtab = true
vim.opt_local.makeprg = "pylint"
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

local function find_virtual_environment()
  return vim.fs.find({ "env", "venv", ".env", ".venv" }, {
    path = vim.api.nvim_buf_get_name(0),
    upward = true,
    stop = vim.loop.os_homedir(),
    type = "directory",
  })[1]
end

vim.keymap.set(
  "n",
  [[gh]],
  [[<Cmd>up | !ruff format %<CR>]],
  { buffer = true, desc = "Call `ruff format` on current buffer" }
)
vim.keymap.set(
  "ia",
  [[def]],
  [[def() -> None:pass<Left><Left><Left><Left><Left><Up>]],
  { buffer = true, desc = "Populate buffer with function definition" }
)
vim.keymap.set("n", [[<leader><CR>]], function()
  local virtual_environment = find_virtual_environment()

  local variables
  if virtual_environment then
    variables = "PATH='"
      .. virtual_environment
      .. "/bin:"
      .. vim.fn.getenv "PATH"
      .. "' "
  else
    variables = ""
  end

  vim.cmd.update()
  vim.cmd.new()

  vim.cmd.terminal(variables .. "sh -c 'python #'")
  vim.cmd.startinsert()
end, { buffer = true, desc = "Run current buffer" })
vim.keymap.set("n", [[<leader><Tab>]], function()
  local virtual_environment = find_virtual_environment()

  local variables
  if virtual_environment then
    variables = "VIRTUAL_ENV='" .. virtual_environment .. "' "
  else
    variables = ""
  end

  vim.cmd.update()
  vim.cmd.new()

  vim.cmd.terminal(variables .. "ipython --no-banner -i '#'")
  vim.cmd.startinsert()
end, { buffer = true, desc = "Load current buffer to ipython" })
