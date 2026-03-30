return {
  {
    "andrewferrier/debugprint.nvim",
    dependencies = {
      "nvim-mini/mini.hipatterns", -- Optional: Needed for line highlighting ('fine-grained' hipatterns plugin)
      "folke/snacks.nvim", -- Optional: If you want to use the `:Debugprint search` command with snacks.nvim
    },
    lazy = false,
    version = "*",
    opts = {
      keymaps = {
        normal = {
          -- creation
          plain_below = "g?p",
          plain_above = "g?P",
          variable_below = "g?v",
          variable_above = "g?V",
          surround_plain = "g?sp",
          surround_variable = "g?sv",
          textobj_below = "g?o",
          textobj_above = "g?O",
          textobj_surround = "g?so",
          -- management (gpx…)
          toggle_comment_debug_prints = "g?xc",
          delete_debug_prints = "g?xd",
          reset_counter = "g?xr", -- not in docs but supported
          search = "g?xs",
          qflist = "g?xq",
        },

        insert = {
          plain = "<C-G>p",
          variable = "<C-G>v",
        },
        visual = {
          variable_below = "g?v",
          variable_above = "g?V",
        },
      },
    },
    keys = {
      { "g?xr", "<cmd>Debugprint resetcounter<CR>", desc = "Reset debug print counter" },
      { "g?xs", "<cmd>Debugprint search<CR>", desc = "Search debug prints (project)" },
      { "g?xq", "<cmd>Debugprint qflist<CR>", desc = "Debug prints → quickfix" },
    },
  },
}
