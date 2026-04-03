-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- You can also add or configure plugins by creating files in this `plugins/` folder
-- PLEASE REMOVE THE EXAMPLES YOU HAVE NO INTEREST IN BEFORE ENABLING THIS FILE
-- Here are some examples:
---@type LazySpec
return { -- == Examples of Adding Plugins ==
  -- customize dashboard options
  -- You can disable default plugins as follows:
  {
    "max397574/better-escape.nvim",
    enabled = false,
  },
  {
    "nvimtools/none-ls.nvim",
    enabled = false,
  },
  {
    "jay-babu/mason-null-ls.nvim",
    enabled = false,
  },

  { "Vimjas/vim-python-pep8-indent" },

  -- { "lepture/vim-jinja" },

  {
    "nvim-mini/mini.move",
    version = false,
    opts = {},
  },

  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = function(_, opts)
      require("luasnip.loaders.from_vscode").lazy_load()
      return opts
    end,
  },

  -- Lorem ipsum generator
  {
    "derektata/lorem.nvim",
    config = function()
      require("lorem").opts {
        sentence_length = "mixed", -- using a default configuration
        comma_chance = 0.3, -- 30% chance to insert a comma
        max_commas = 2, -- maximum 2 commas per sentence
        debounce_ms = 200, -- default debounce time in milliseconds
        -- required by type
        format_defaults = {}, -- empty table is fine
        paragraph_length = "mixed", -- optional, you can customize
        words = {}, -- optional, defaults
      }
    end,
  },

  {
    "olrtg/nvim-emmet",
    ft = { "html", "css", "scss", "sass", "javascript", "htmldjango" },
    config = function() vim.keymap.set({ "n", "v" }, "<A-S-w>", require("nvim-emmet").wrap_with_abbreviation) end,
  },

  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
      { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
    },
  },

  {
    "dstein64/nvim-scrollview",
    opts = {
      -- signs_on_startup = { "diagnostics" },
      mode = "simple", -- lighter refresh, less flicker
      -- current_only = true, -- fewer windows to redraw
    },
  },

  {
    "andymass/vim-matchup",
    event = "User AstroFile",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter", optional = true },
      {
        "AstroNvim/astrocore",
        opts = {
          options = {
            g = {
              matchup_matchparen_nomode = "i",
              matchup_matchparen_deferred = 1,
              matchup_matchparen_offscreen = { method = "popup" },
              matchup_treesitter_stopline = 500,
              matchup_treesitter_enabled = true,
            },
          },
        },
      },
    },
    config = function()
      -- Disable matchup highlighting only for Django / Jinja templates
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "htmldjango", "django", "jinja", "jinja2" },
        callback = function()
          vim.b.matchup_matchparen_enabled = 0
          -- vim.b.matchup_matchparen_fallback = 0
        end,
      })
    end,
  },

  {
    "windwp/nvim-autopairs",
    config = function(plugin, opts)
      require "astronvim.plugins.configs.nvim-autopairs"(plugin, opts)
      local npairs = require "nvim-autopairs"
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"

      -- add django rules
      npairs.add_rules {
        Rule("%", "%", { "htmldjango", "django" })
          :with_pair(function(opts)
            -- Only double % when it follows {
            return opts.line:sub(opts.col - 1, opts.col - 1) == "{"
          end)
          :with_move(cond.none())
          :with_cr(cond.none())
          :with_del(cond.none()),

        Rule("#", "#", { "htmldjango", "django" })
          :with_pair(function(opts) return opts.line:sub(opts.col - 1, opts.col - 1) == "{" end)
          :with_move(cond.none())
          :with_cr(cond.none())
          :with_del(cond.none()),
      }
    end,
  },

  { "nvim-tree/nvim-web-devicons", opts = {} },

  {
    "saghen/filler-begone.nvim",
    dependencies = {
      {
        "AstroNvim/astrocore",
        opts = {
          options = {
            g = {
              filler_begone = true, -- or remove this line entirely
            },
          },
          autocmds = {
            filler_begone = {
              {
                event = "BufEnter",
                pattern = "*",
                callback = function(args)
                  local bt = vim.bo[args.buf].buftype
                  local allow = { nofile = true, terminal = true, prompt = true }
                  if allow[bt] then
                    vim.b[args.buf].filler_begone = true -- enabled (default)
                  else
                    vim.b[args.buf].filler_begone = false -- disable for everything else
                  end
                end,
              },
            },
          },
        },
      },
    },
  },
}
