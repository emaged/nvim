-- if true then return {} end
return {
  "folke/noice.nvim",
  opts = {
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
    lsp = {
      hover = {
        enabled = false,
      },
      signature = {
        enabled = false,
      },
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      progress = {
        enabled = false,
        -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
        -- See the section on formatting for more details on how to customize.
        --- @type NoiceFormat|string
        -- format = "lsp_progress",
        --- @type NoiceFormat|string
        -- format_done = "lsp_progress_done",
        -- throttle = 1000 / 30, -- frequency to update lsp progress message
        -- view = "mini",
      },
    },
  },

  keys = {
    -- Clear search + dismiss Noice
    {
      "<Leader>Nl",
      function() require("noice").cmd "last" end,
      mode = "n",
      desc = "Noice Last Message",
    },
    -- Noice message history
    {
      "<Leader>Nh",
      function() require("noice").cmd "history" end,
      mode = "n",
      desc = "Noice History",
    },
    -- Noice message dismiss
    {
      "<Leader>Nd",
      function() require("noice").cmd "dismiss" end,
      mode = "n",
      desc = "Noice Dismiss",
    },
    -- Noice message errors
    {
      "<Leader>Ne",
      function() require("noice").cmd "errors" end,
      mode = "n",
      desc = "Noice Errors",
    },
    -- Noice disable
    {
      "<Leader>ND",
      function() require("noice").cmd "disable" end,
      mode = "n",
      desc = "Noice Disable",
    },
    -- Noice enable
    {
      "<Leader>NE",
      function() require("noice").cmd "enable" end,
      mode = "n",
      desc = "Noice Enable",
    },
    -- Noice stats
    {
      "<Leader>Ns",
      function() require("noice").cmd "stats" end,
      mode = "n",
      desc = "Noice Stats",
    },
    -- Noice messages
    {
      "<Leader>Nm",
      function() require("noice").cmd "messages" end,
      mode = "n",
      desc = "Noice Messages",
    },
    -- Noice stats
    {
      "<Leader>Np",
      function() require("noice").cmd "pick" end,
      mode = "n",
      desc = "Noice Picker",
    },
    -- Redirect commandline with Shift-Enter
    {
      "<S-Enter>",
      function() require("noice").redirect(vim.fn.getcmdline()) end,
      mode = "c",
      desc = "Redirect Cmdline",
    },
    -- Noice LSP scrolling (<C-f>)
    {
      "<C-f>",
      function()
        if not require("noice.lsp").scroll(4) then return "<C-f>" end
      end,
      mode = { "n", "i", "s" },
      expr = true,
      silent = true,
      desc = "Noice LSP scroll (down)",
    },
    -- Noice LSP scrolling (<C-b>)
    {
      "<C-b>",
      function()
        if not require("noice.lsp").scroll(-4) then return "<C-b>" end
      end,
      mode = { "n", "i", "s" },
      expr = true,
      silent = true,
      desc = "Noice LSP scroll (up)",
    },
  },
}
