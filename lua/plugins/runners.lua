return {
  {
    "michaelb/sniprun",
    branch = "master",
    build = "sh install.sh 1",
    -- do 'sh install.sh 1' if you want to force compile locally
    -- (instead of fetching a binary from the github release). Requires Rust >= 1.65
    keys = {
      -- Run current line / motion / selection
      { "<Leader>rr", "<Plug>SnipRun", mode = { "n", "v" }, desc = "Run snippet / selection" },
      { "<Leader>rf", "<Plug>SnipRunOperator", desc = "Run via operator (motion)" },
      -- Info & status
      { "<Leader>ri", "<Plug>SnipInfo", desc = "SnipRun info" },
      -- Session management
      { "<Leader>rz", "<Plug>SnipReset", desc = "Reset SnipRun" },
      { "<Leader>rc", "<Plug>SnipReplMemoryClean", desc = "Clear SnipRun REPL memory" },
      { "<Leader>rx", "<Plug>SnipClose", desc = "Close SnipRun windows" },
      -- Live mode (auto-run on edit)
      -- { "<Leader>rl", "<Plug>SnipLive", desc = "Toggle SnipRun live mode" },
    },

    config = function()
      require("sniprun").setup {
        selected_interpreters = { "Python3_fifo" },
        repl_enable = { "Python3_fifo" },
        display = { "Terminal" },
        display_options = {
          terminal_scrollback = vim.o.scrollback, -- change terminal display scrollback lines
          terminal_line_number = false, -- whether show line number in terminal window
          terminal_signcolumn = false, -- whether show signcolumn in terminal window
          terminal_position = "vertical", --# or "horizontal", to open as horizontal split instead of vertical split
          -- terminal_width = 45, --# change the terminal display option width (if vertical)
          -- terminal_height = 20, --# change the terminal display option height (if horizontal)
        },
      }
    end,
  },

  {
    "stevearc/overseer.nvim",
    dependencies = { "franco-ruggeri/overseer-extra.nvim" },
    opts = function(_, opts)
      opts.templates = opts.templates or {}
      vim.list_extend(opts.templates, { "extra" })
      return opts
    end,
  },
}
