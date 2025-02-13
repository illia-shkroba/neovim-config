return {
  "ggandor/leap.nvim",
  config = function()
    local set = vim.keymap.set

    local leap = require "leap"
    leap.opts.case_sensitive = true

    set(
      { "n", "v", "o" },
      [[<C-s>]],
      "<Plug>(leap)",
      { silent = true, desc = "Leap" }
    )
    set(
      { "n", "v", "o" },
      "gs",
      "<Plug>(leap)",
      { silent = true, desc = "Leap" }
    )
    set({ "i" }, [[<C-s>]], "<Plug>(leap)", { silent = true, desc = "Leap" })
  end,
}
