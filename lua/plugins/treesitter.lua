return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local treesitter = require "nvim-treesitter"

    treesitter.install {
      "bash",
      "c_sharp",
      "dockerfile",
      "dot",
      "haskell",
      "java",
      "json",
      "latex",
      "lua",
      "markdown",
      "nginx",
      "perl",
      "purescript",
      "python",
      "rust",
      "sql",
      "terraform",
      "vim",
      "vimdoc",
      "yaml",
    }
  end,
}
