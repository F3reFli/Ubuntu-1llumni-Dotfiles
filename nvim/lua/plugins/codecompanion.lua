return {
  {
    "olimorris/codecompanion.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      return {
        strategies = {
          chat = { adapter = "ollama" },
          inline = { adapter = "ollama" },
        },
        adapters = {
          http = {
            ollama = function()
              return require("codecompanion.adapters").extend("openai_compatible", {
                env = { url = "http://localhost:11434" },
                opts = {
                  model = "llama3.1:8b",
                  stream = true,
                },
              })
            end,
          },
        },
        display = {
          chat = {
            window = {
              layout = "vertical",
              position = "right",
              width = 0.40,
              height = 0.85,
              border = "single",
            },
            token_count = function(tokens)
              return " (" .. tokens .. " tokens)"
            end,
          },
        },
      }
    end,
    keys = function()
      return {
        { "<C-a>", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Action palette" },
        { "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle chat" },
        { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to chat" },
      }
    end,
  },
}
