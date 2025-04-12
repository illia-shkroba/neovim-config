return {
  "illia-shkroba/telescope-completion.nvim",
  dependencies = { "nvim-telescope/telescope.nvim" },
  config = function()
    local completion = require("telescope").load_extension "completion"

    vim.keymap.set("i", [[<C-z>]], function()
      if vim.fn.pumvisible() == 1 then
        return completion.completion_expr()
      else
        return [[<C-z>]]
      end
    end, { expr = true, desc = "List popup-menu completion in Telescope" })
  end,
}
