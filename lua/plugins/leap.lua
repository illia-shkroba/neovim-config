return {
  "ggandor/leap.nvim",
  config = function()
    local set = vim.keymap.set

    local leap = require "leap"
    leap.opts.case_sensitive = true

    set(
      { "n", "x", "o" },
      "gs",
      "<Plug>(leap)",
      { silent = true, desc = "Leap" }
    )
  end,
}
