return {
  "ggandor/leap.nvim",
  config = function()
    local set = vim.keymap.set

    local leap = require "leap"
    leap.opts.case_sensitive = true

    set(
      { "n", "x", "o" },
      "s",
      "<Plug>(leap-forward)",
      { silent = true, desc = "Leap forward" }
    )
    set(
      { "n", "x", "o" },
      "S",
      "<Plug>(leap-backward)",
      { silent = true, desc = "Leap backward" }
    )
    set(
      { "n", "x", "o" },
      "gs",
      "<Plug>(leap-from-window)",
      { silent = true, desc = "Leap from window" }
    )
  end,
}
