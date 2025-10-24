return {
  "ggandor/leap.nvim",
  config = function()
    local leap = require "leap"
    local leap_user = require "leap.user"

    leap.opts.vim_opts["go.ignorecase"] = true
    leap.opts.safe_labels = "sfnutrhjklx"
    leap.opts.labels = "abcdefghijklmnopqrstuvwxyz"

    leap_user.set_repeat_keys("<C-n>", "<C-p>", {
      -- If set to true, the keys will work like the native
      -- semicolon/comma, i.e., forward/backward is understood in
      -- relation to the last motion.
      relative_directions = false,
      modes = { "n", "x", "o" },
    })

    vim.keymap.set(
      { "n", "o" },
      [[<C-z>]],
      require("leap.remote").action,
      { silent = true, desc = "Perform remote action with Leap" }
    )
    vim.keymap.set(
      { "n", "v", "o" },
      [[<C-s>]],
      "<Plug>(leap)",
      { silent = true, desc = "Leap" }
    )
    vim.keymap.set(
      { "n", "v", "o" },
      [[<C-q>]],
      "<Plug>(leap-from-window)",
      { silent = true, desc = "Leap to other windows" }
    )
    vim.keymap.set(
      { "i" },
      [[<C-s>]],
      "<Plug>(leap)",
      { silent = true, desc = "Leap" }
    )
    vim.keymap.set(
      { "i" },
      [[<C-q>]],
      "<Plug>(leap-from-window)",
      { silent = true, desc = "Leap to other windows" }
    )
  end,
}
