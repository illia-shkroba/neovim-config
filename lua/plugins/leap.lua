return {
  "ggandor/leap.nvim",
  config = function()
    local set = vim.keymap.set

    local leap = require "leap"
    leap.opts.case_sensitive = false
    leap.opts.safe_labels = "sfnutrhjklx"
    leap.opts.labels = "abcdefghijklmnopqrstuvwxyz"

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
  end,
}
