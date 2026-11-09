if vim.b.did_python_ftplugin then
  return
end
vim.b.did_python_ftplugin = true

vim.opt_local.errorformat = "%f:%l:%c: %m"
vim.opt_local.expandtab = true
vim.opt_local.makeprg =
  "ruff check --output-format=concise --extend-exclude '*.ipynb'"
vim.opt_local.shiftwidth = 4
vim.opt_local.softtabstop = 4
vim.opt_local.tabstop = 4

local function find_venv()
  return vim.fs.find({ "env", "venv", ".env", ".venv" }, {
    path = vim.api.nvim_buf_get_name(0),
    upward = true,
    stop = vim.uv.os_homedir(),
    type = "directory",
  })[1]
end

local function venv_bin(name)
  local venv = find_venv()
  if not venv then
    return name
  end
  return vim.fs.joinpath(venv, "bin", name)
end

vim.treesitter.start()

vim.api.nvim_create_autocmd("BufReadPost", {
  buf = vim.api.nvim_get_current_buf(),
  callback = function()
    vim.treesitter.start()
  end,
})

vim.keymap.set(
  "n",
  [[<leader>tf]],
  [[<Cmd>up | !ruff format %:S && ruff check --fix %:S<CR>]],
  { buffer = true, desc = "Call `ruff format` on current buffer" }
)
vim.keymap.set(
  "ia",
  [[def]],
  [[def() -> None:<CR>pass<Left><Left><Left><Left><Left><Up>]],
  { buffer = true, desc = "Populate buffer with function definition" }
)
vim.keymap.set("n", [[<leader><CR>]], function()
  vim.cmd.update()
  vim.cmd.new()

  vim.cmd.terminal(venv_bin "python" .. " #:S")
  vim.cmd.startinsert()
end, { buffer = true, desc = "Run current buffer" })
vim.keymap.set("n", [[<leader><Tab>]], function()
  vim.cmd.update()
  vim.cmd.new()

  vim.cmd.terminal(venv_bin "ipython" .. " --no-banner -i #:S")
  vim.cmd.startinsert()
end, { buffer = true, desc = "Load current buffer to ipython" })
