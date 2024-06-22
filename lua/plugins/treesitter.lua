return {
  "nvim-treesitter/nvim-treesitter",
  build = function()
    local ts_update =
      require("nvim-treesitter.install").update { with_sync = true }
    ts_update()
  end,
  config = function()
    require("nvim-treesitter.configs").setup {
      ensure_installed = {
        "bash",
        "c_sharp",
        "dockerfile",
        "haskell",
        "java",
        "json",
        "lua",
        "markdown",
        "nix",
        "python",
        "sql",
        "terraform",
        "vim",
        "vimdoc",
        "yaml",
      },
      sync_install = false,
      auto_install = false,

      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    }
  end,
}
