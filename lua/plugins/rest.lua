return {
  {
    "rest-nvim/rest.nvim",
    ft = "http",
    cmd = "Rest",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      {
        "AstroNvim/astrocore",
        opts = {
          treesitter = { ensure_installed = { "http" } },
          mappings = {
            n = {
              ["<Leader>k"] = { desc = "REST client" },
            },
          },
        },
      },
    },
    keys = {
      { "<Leader>kr", "<cmd>Rest run<cr>", desc = "Run request under the cursor" },
      { "<Leader>kl", "<cmd>Rest last<cr>", desc = "Re-run last request" },
      { "<Leader>ke", "<cmd>Rest env select<cr>", desc = "Select REST environment" },
    },
  },
}
