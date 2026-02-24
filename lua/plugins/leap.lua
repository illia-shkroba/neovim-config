return {
  url = "https://codeberg.org/andyg/leap.nvim",
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
  end,
}
