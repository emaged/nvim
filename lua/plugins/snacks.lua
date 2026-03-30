return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          files = {
            exclude = {
              "__pycache__",
              ".venv",
              "venv",
            },
          },
          --   explorer = {
          --     exclude = {
          --       "__pycache__",
          --       ".venv",
          --       "venv",
          --     },
          --   },
        },
      },
    },
  },
}
