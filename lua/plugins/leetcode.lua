return {
  {
    "kawre/leetcode.nvim",
    cmd = "Leet", -- only load when you use it
    build = ":TSUpdate html", -- if you have `nvim-treesitter` installed
    dependencies = {
      -- include a picker of your choice, see picker section for more details
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      ---@type lc.lang
      lang = "c",
    },
  },
}
