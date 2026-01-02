return {
  "AckslD/nvim-neoclip.lua",
  dependencies = { "ibhagwan/fzf-lua" },
  config = function()
    require("neoclip").setup {
      keys = {
        fzf = {
          select = "default",
          paste = false,
          paste_behind = false,
        },
      },
    }
  end,
}
