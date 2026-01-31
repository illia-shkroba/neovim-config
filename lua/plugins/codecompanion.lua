local command = { "ollama", "list" }
local result = vim.system(command, { text = true }):wait()

if result.code == 0 then
  local default_model

  local env_model = os.getenv "OLLAMA_MODEL"
  local lines = vim.split(result.stdout, "\n")

  if env_model ~= nil then
    default_model = env_model
  elseif #lines == 3 then
    -- The third line is empty.
    default_model = lines[2]:gsub("^([^%s]+).*$", "%1")
  end

  local local_config = default_model ~= nil
      and {
        adapter = {
          name = "ollama",
          model = default_model,
        },
      }
    or nil

  return {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("codecompanion").setup {
        interactions = {
          chat = local_config,
          inline = local_config,
          cmd = local_config,
          background = local_config,
        },
        opts = {
          log_level = "DEBUG",
        },
      }
    end,
  }
else
  return {}
end
