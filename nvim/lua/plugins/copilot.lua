return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    build = ":Copilot auth",
    event = "InsertEnter",
    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
        debounce = 75,
        keymap = { accept = "<S-Tab>" },
      },
      panel = {
        enabled = true,
        auto_refresh = true,
      },
      filetypes = { ["*"] = true },
    },
  },
}
