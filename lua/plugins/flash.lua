return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    labels = "asdfghjkl",
    search = {
      -- search/jump in all windows
      multi_window = true,
      -- search direction
      forward = true,
      -- when `false`, find only matches in the given direction
      wrap = true,
      ---@type Flash.Pattern.Mode
      -- Each mode will take ignorecase and smartcase into account.
      -- * exact: exact match
      -- * search: regular search
      -- * fuzzy: fuzzy search
      -- * fun(str): custom function that returns a pattern
      --   For example, to only match at the beginning of a word:
      --   mode = function(str)
      --     return "\\<" .. str
      --   end,
      mode = "exact",
      -- behave like `incsearch`. Don't use it - it is buggy.
      incremental = false,
      -- Excluded filetypes and custom window filters
      ---@type (string|fun(win:window))[]
      exclude = {
        "lazy",
        "flash_prompt",
        function(win)
          -- exclude non-focusable windows
          return not vim.api.nvim_win_get_config(win).focusable
        end,
      },
      -- Optional trigger character that needs to be typed before
      -- a jump label can be used. It's NOT recommended to set this,
      -- unless you know what you're doing
      trigger = "",
      -- max pattern length. If the pattern length is equal to this
      -- labels will no longer be skipped. When it exceeds this length
      -- it will either end in a jump or terminate the search
      max_length = false, ---@type number|false
    },
    jump = {
      -- save location in the jumplist
      jumplist = true,
      -- jump position
      pos = "start", ---@type "start" | "end" | "range"
      -- add pattern to search history
      history = false,
      -- add pattern to search register
      register = false,
      -- clear highlight after jump
      nohlsearch = false,
      -- automatically jump when there is only one match
      autojump = false,
      -- You can force inclusive/exclusive jumps by setting the
      -- `inclusive` option. By default it will be automatically
      -- set based on the mode.
      inclusive = nil, ---@type boolean?
      -- jump position offset. Not used for range jumps.
      -- 0: default
      -- 1: when pos == "end" and pos < current position
      offset = nil, ---@type number
    },
    label = {
      -- allow uppercase labels
      uppercase = true,
      -- add any labels with the correct case here, that you want to exclude
      exclude = "",
      -- add a label for the first match in the current window.
      -- you can always jump to the first match with `<CR>`
      current = true,
      -- show the label after the match
      after = true, ---@type boolean|number[]
      -- show the label before the match
      before = false, ---@type boolean|number[]
      -- position of the label extmark
      style = "overlay", ---@type "eol" | "overlay" | "right_align" | "inline"
      -- flash tries to re-use labels that were already assigned to a position,
      -- when typing more characters. By default only lower-case labels are re-used.
      reuse = "lowercase", ---@type "lowercase" | "all" | "none"
      -- for the current window, label targets closer to the cursor first
      distance = true,
      -- minimum pattern length to show labels
      -- Ignored for custom labelers.
      min_pattern_length = 0,
      -- Enable this to use rainbow colors to highlight labels
      -- Can be useful for visualizing Treesitter ranges.
      rainbow = {
        enabled = false,
        -- number between 1 and 9
        shade = 5,
      },
      -- With `format`, you can change how the label is rendered.
      -- Should return a list of `[text, highlight]` tuples.
      ---@class Flash.Format
      ---@field state Flash.State
      ---@field match Flash.Match
      ---@field hl_group string
      ---@field after boolean
      ---@type fun(opts:Flash.Format): string[][]
      format = function(opts)
        return { { opts.match.label, opts.hl_group } }
      end,
    },
    highlight = {
      -- show a backdrop with hl FlashBackdrop
      backdrop = true,
      -- Highlight the search matches
      matches = true,
      -- extmark priority
      priority = 5000,
      groups = {
        match = "FlashMatch",
        current = "FlashCurrent",
        backdrop = "FlashBackdrop",
        label = "FlashLabel",
      },
    },
    -- action to perform when picking a label.
    -- defaults to the jumping logic depending on the mode.
    ---@type fun(match:Flash.Match, state:Flash.State)|nil
    action = nil,
    -- initial pattern to use when opening flash
    pattern = "",
    -- When `true`, flash will try to continue the last search
    continue = false,
    -- Set config to a function to dynamically change the config
    config = nil, ---@type fun(opts:Flash.Config)|nil
    -- You can override the default options for a specific mode.
    -- Use it with `require("flash").jump({mode = "forward"})`
    ---@type table<string, Flash.Config>
    modes = {
      search = {
        enabled = false,
      },
      char = {
        enabled = false,
      },
    },
    -- options for the floating window that shows the prompt,
    -- for regular jumps
    -- `require("flash").prompt()` is always available to get the prompt text
    prompt = {
      enabled = true,
      prefix = { { "⚡", "FlashPromptIcon" } },
      win_config = {
        relative = "editor",
        width = 1, -- when <=1 it's a percentage of the editor width
        height = 1,
        row = -1, -- when negative it's an offset from the bottom
        col = 0, -- when negative it's an offset from the right
        zindex = 1000,
      },
    },
  },
  keys = {
    {
      "gs",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "gS",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump { continue = true }
      end,
      desc = "Flash",
    },
  },
}
