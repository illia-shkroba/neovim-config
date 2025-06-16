return {
  "ggandor/leap.nvim",
  config = function()
    local set = vim.keymap.set

    local leap = require "leap"
    local leap_user = require "leap.user"

    leap.opts.case_sensitive = false
    leap.opts.safe_labels = "sfnutrhjklx"
    leap.opts.labels = "abcdefghijklmnopqrstuvwxyz"

    leap_user.set_repeat_keys("<C-n>", "<C-p>", {
      -- If set to true, the keys will work like the native
      -- semicolon/comma, i.e., forward/backward is understood in
      -- relation to the last motion.
      relative_directions = false,
      modes = { "n", "x", "o" },
    })

    set({ "n", "v", "o" }, [[<C-k>]], function()
      require("leap.remote").action()
    end, { silent = true, desc = "Remote action" })
    set(
      { "n", "v", "o" },
      [[<C-s>]],
      "<Plug>(leap)",
      { silent = true, desc = "Leap" }
    )
    set(
      { "n", "v", "o" },
      [[gs]],
      "<Plug>(leap-from-window)",
      { silent = true, desc = "Leap to other windows" }
    )
    set({ "i" }, [[<C-s>]], "<Plug>(leap)", { silent = true, desc = "Leap" })
    set(
      { "i" },
      [[<C-g><C-s>]],
      "<Plug>(leap-from-window)",
      { silent = true, desc = "Leap to other windows" }
    )
  end,
}
