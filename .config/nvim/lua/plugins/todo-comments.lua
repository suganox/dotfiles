return {
  "folke/todo-comments.nvim",
  event = 'VimEnter',
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = false,
    highlight = {
      pattern = [[.*<(KEYWORDS)]],
      after = "",
    },
    search = {
      pattern = [[\b(KEYWORDS)\b]],
    }
  },
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next Todo Comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous Todo Comment" },
    { "<C-f><C-t>", "<cmd>TodoTelescope<cr>", desc = "Todo" },
  },
}
