return {
  "monaqa/dial.nvim",
  lazy = true,
  dependencies = {
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {
            ["<C-a>"] = {
              function() return require("dial.map").manipulate("increment", "normal") end,
              desc = "Increment",
            },
            ["<C-x>"] = {
              function() return require("dial.map").manipulate("decrement", "normal") end,
              desc = "Decrement",
            },
            ["g<C-a>"] = {
              function() return require("dial.map").manipulate("increment", "gnormal") end,
              desc = "Increment",
            },
            ["g<C-x>"] = {
              function() return require("dial.map").manipulate("decrement", "gnormal") end,
              desc = "Decrement",
            },
          },
          v = {
            ["<C-a>"] = {
              function() return require("dial.map").manipulate("increment", "visual") end,
              desc = "Increment",
            },
            ["<C-x>"] = {
              function() return require("dial.map").manipulate("decrement", "visual") end,
              desc = "Decrement",
            },
          },
          x = {
            ["g<C-a>"] = {
              function() return require("dial.map").manipulate("increment", "gvisual") end,
              desc = "Increment",
            },
            ["g<C-x>"] = {
              function() return require("dial.map").manipulate("decrement", "gvisual") end,
              desc = "Decrement",
            },
          },
        },
      },
    },
  },

  config = function()
    local augend = require "dial.augend"

    ----------------------------------------------------------------------
    -- LazyVim-style custom augends
    ----------------------------------------------------------------------

    local logical_alias = augend.constant.new {
      elements = { "&&", "||" },
      word = false,
      cyclic = true,
    }

    local ordinal_numbers = augend.constant.new {
      elements = {
        "first",
        "second",
        "third",
        "fourth",
        "fifth",
        "sixth",
        "seventh",
        "eighth",
        "ninth",
        "tenth",
      },
      word = false,
      cyclic = true,
    }

    local ordinal_numbers_cap = augend.constant.new {
      elements = {
        "First",
        "Second",
        "Third",
        "Fourth",
        "Fifth",
        "Sixth",
        "Seventh",
        "Eighth",
        "Ninth",
        "Tenth",
      },
      word = false,
      cyclic = true,
    }

    local weekdays = augend.constant.new {
      elements = {
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday",
        "Sunday",
      },
      word = true,
      cyclic = true,
    }

    local months = augend.constant.new {
      elements = {
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      },
      word = true,
      cyclic = true,
    }

    local capitalized_boolean = augend.constant.new {
      elements = { "True", "False" },
      word = true,
      cyclic = true,
    }

    ----------------------------------------------------------------------
    -- Groups (LazyVim structure + Astro additions)
    ----------------------------------------------------------------------

    local groups = {
      default = {
        -- numbers
        augend.integer.alias.decimal,
        augend.integer.alias.decimal_int,
        augend.integer.alias.hex,

        -- dates
        augend.date.alias["%Y/%m/%d"],
        augend.date.alias["%Y-%m-%d"],

        -- versions
        augend.semver.alias.semver,

        -- booleans
        augend.constant.alias.bool,
        capitalized_boolean,

        -- words
        ordinal_numbers,
        ordinal_numbers_cap,
        weekdays,
        months,

        -- logical
        logical_alias,

        -- case switching (AstroCommunity)
        -- augend.case.new {
        --   types = {
        --     "camelCase",
        --     "PascalCase",
        --     "snake_case",
        --     "SCREAMING_SNAKE_CASE",
        --   },
        -- },
      },

      typescript = {
        augend.constant.new {
          elements = { "let", "const" },
          cyclic = true,
        },

        augend.constant.new {
          elements = { "==", "===" },
          cyclic = true,
        },

        augend.constant.new {
          elements = { "!=", "!==" },
          cyclic = true,
        },
      },

      css = {
        augend.hexcolor.new { case = "lower" },
        augend.hexcolor.new { case = "upper" },

        augend.constant.new {
          elements = { "px", "rem", "em", "%" },
          word = false,
          cyclic = true,
        },
      },

      markdown = {
        augend.constant.new {
          elements = { "[ ]", "[x]" },
          word = false,
          cyclic = true,
        },
        augend.misc.alias.markdown_header,
      },

      lua = {
        augend.constant.new {
          elements = { "and", "or" },
          word = true,
          cyclic = true,
        },
      },

      python = {
        augend.constant.new {
          elements = { "and", "or" },
          cyclic = true,
        },
      },
    }

    ----------------------------------------------------------------------
    -- Extend default group into others (LazyVim trick)
    ----------------------------------------------------------------------

    for name, group in pairs(groups) do
      if name ~= "default" then vim.list_extend(group, groups.default) end
    end

    require("dial.config").augends:register_group(groups)

    ----------------------------------------------------------------------
    -- Filetype mapping (LazyVim behavior)
    ----------------------------------------------------------------------

    vim.g.dials_by_ft = {
      css = "css",
      scss = "css",
      sass = "css",
      vue = "typescript",
      javascript = "typescript",
      javascriptreact = "typescript",
      typescript = "typescript",
      typescriptreact = "typescript",
      json = "json",
      markdown = "markdown",
      lua = "lua",
      python = "python",
    }
  end,
}
