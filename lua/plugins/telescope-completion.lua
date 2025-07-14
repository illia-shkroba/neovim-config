return {
  "illia-shkroba/telescope-completion.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    -- `telescope-completion` and `leap` share the same contextual binding <C-z>.
    "ggandor/leap.nvim",
  },
  config = function()
    local completion = require("telescope").load_extension "completion"

    vim.keymap.set("i", [[<C-z>]], function()
      if vim.fn.pumvisible() == 1 then
        return completion.completion_expr()
      else
        return [[:lua require("leap.remote").action()<CR>]]
      end
    end, {
      expr = true,
      silent = true,
      desc = "Display popup-menu completions using Telescope when the menu is visible; otherwise, perform remote action with Leap",
    })
  end,
}
