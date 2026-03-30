return {
  {
    "gbprod/yanky.nvim",
    opts = function(_, opts)
      local astrocore = require "astrocore"

      local is_windows = vim.fn.has "win32" == 1
      local is_vscode = vim.g.vscode ~= nil

      opts = astrocore.extend_tbl(opts, {
        highlight = { timer = 200 },
        ring = {
          storage = (is_windows or is_vscode) and "shada" or "sqlite",
          ignore_registers = { "*", "_" }, -- probably not needed
        },
        system_clipboard = {
          clipboard_register = "+", -- default is primary selection
          sync_with_ring = true,
        },
      })
      return opts
    end,
  },
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["yp"] = { "<Plug>(YankyPreviousEntry)", desc = "Yank history: previous entry" },
          ["yn"] = { "<Plug>(YankyNextEntry)", desc = "Yank history: next entry" },

          [",pc"] = { "<Plug>(YankyPutAfterCharwise)", desc = "Put charwise (preserve newlines)" },
          [",pC"] = { "<Plug>(YankyPutBeforeCharwise)", desc = "Put charwise before (preserve newlines)" },
          [",pj"] = { "<Plug>(YankyPutAfterCharwiseJoined)", desc = "Put charwise joined" },
          [",pJ"] = { "<Plug>(YankyPutBeforeCharwiseJoined)", desc = "Put charwise joined before" },
        },
        x = {
          [",pC"] = { "<Plug>(YankyPutBeforeCharwise)", desc = "Put charwise before (preserve newlines)" },
          [",pc"] = { "<Plug>(YankyPutAfterCharwise)", desc = "Put charwise (preserve newlines)" },
          [",pj"] = { "<Plug>(YankyPutAfterCharwiseJoined)", desc = "Put charwise joined" },
          [",pJ"] = { "<Plug>(YankyPutBeforeCharwiseJoined)", desc = "Put charwise joined before" },
        },
      },
    },
  },
}
