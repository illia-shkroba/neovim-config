return {
  "folke/tokyonight.nvim",
  branch = "main",
  config = function()
    require("tokyonight").setup {
      style = "moon",
      transparent = true,
      terminal_colors = true,
      dim_inactive = true,
    }

    vim.cmd [[
        colorscheme tokyonight-moon
        highlight clear LineNr
      ]]

    vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "gray", bold = true })
    vim.api.nvim_set_hl(0, "LineNr", { fg = "white", bold = true })
    vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "gray", bold = true })
  end,
}
