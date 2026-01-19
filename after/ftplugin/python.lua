if vim.b.did_python_ftplugin then
  return
end
vim.b.did_python_ftplugin = true

vim.opt_local.expandtab = true
vim.opt_local.makeprg = "pylint"
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

local function find_venv()
  return vim.fs.find({ "env", "venv", ".env", ".venv" }, {
    path = vim.api.nvim_buf_get_name(0),
    upward = true,
    stop = vim.loop.os_homedir(),
    type = "directory",
  })[1]
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "<filetype>" },
  callback = function()
    vim.treesitter.start()
  end,
})

vim.keymap.set(
  "n",
  [[gh]],
  [[<Cmd>up | !ruff format % | ruff check --fix %<CR>]],
  { buffer = true, desc = "Call `ruff format` on current buffer" }
)
vim.keymap.set(
  "ia",
  [[def]],
  [[def() -> None:pass<Left><Left><Left><Left><Left><Up>]],
  { buffer = true, desc = "Populate buffer with function definition" }
)
vim.keymap.set("n", [[<leader><CR>]], function()
  local venv = find_venv()

  local venv_activation = venv
      and "source " .. vim.fs.joinpath(venv, "bin", "activate") .. " && "
    or ""

  vim.cmd.update()
  vim.cmd.new()

  vim.cmd.terminal(venv_activation .. "python '#'")
  vim.cmd.startinsert()
end, { buffer = true, desc = "Run current buffer" })
vim.keymap.set("n", [[<leader><Tab>]], function()
  local venv = find_venv()

  local venv_activation = venv
      and "source " .. vim.fs.joinpath(venv, "bin", "activate") .. " && "
    or ""

  vim.cmd.update()
  vim.cmd.new()

  vim.cmd.terminal(venv_activation .. "ipython --no-banner -i '#'")
  vim.cmd.startinsert()
end, { buffer = true, desc = "Load current buffer to ipython" })
