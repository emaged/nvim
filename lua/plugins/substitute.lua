return {
  {
    "gbprod/substitute.nvim",
    cond = true,
    keys = {
      { "gs", function() require("substitute").operator() end, mode = "n", desc = "Substitute operator" },
      { "gss", function() require("substitute").line() end, mode = "n", desc = "Substitute line" },
      { "gS", function() require("substitute").eol() end, mode = "n", desc = "Substitute eol" },
      { "gs", function() require("substitute").visual() end, mode = "x", desc = "Substitute selection" },

      {
        "<localleader>s",
        function() require("substitute.range").operator() end,
        mode = "n",
        desc = "Substitute range",
      },
      { "<localleader>s", function() require("substitute.range").visual() end, mode = "x", desc = "Substitute range" },
      {
        "<localleader>ss",
        function() require("substitute.range").word() end,
        mode = "n",
        desc = "Substitute word",
      },
      {
        "<localleader>sb",
        function() require("substitute.range").operator { range = "%" } end,
        mode = { "n", "v" },
        desc = "Substitute in whole buffer",
      },

      {
        "gsx",
        function() require("substitute.exchange").operator() end,
        mode = "n",
        desc = "Substitute exchange operator",
      },
      { "gsxx", function() require("substitute.exchange").line() end, mode = "n", desc = "Substitute exchange line" },
      {
        "gsX",
        function() require("substitute.exchange").operator { motion = "$" } end,
        mode = "n",
        desc = "Substitute exchange eol",
      },
      {
        "X",
        function() require("substitute.exchange").visual() end,
        mode = "x",
        desc = "Substitute exchange selection",
      },
      { "gsxc", function() require("substitute.exchange").cancel() end, mode = "n", desc = "Substitute cancel" },
    },

    opts = {
      on_substitute = require("yanky.integration").substitute(),
      highlight_substituted_text = {
        enabled = true,
        timer = 200,
      },
    },
  },
}
