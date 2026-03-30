return {
  {
    "jmbuhr/otter.nvim",

    -- Lazy load when needed
    ft = { "html" },

    keys = {
      {
        "<Leader>Ia",
        function() require("otter").activate() end,
        desc = "Otter: Activate Javascript",
      },
      {
        "<Leader>Il",
        "<cmd>ls!<cr>",
        desc = "Otter: List buffers",
      },
      {
        "<Leader>Ii",
        "<cmd>LspInfo<cr>",
        desc = "Otter: LSP info",
      },
    },

    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
  },
}
