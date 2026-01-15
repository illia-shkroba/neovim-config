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
      "haskell",
      "java",
      "json",
      "lua",
      "markdown",
      "nix",
      "purescript",
      "python",
      "sql",
      "terraform",
      "vim",
      "vimdoc",
      "yaml",
    }
  end,
}
