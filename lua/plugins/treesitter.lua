-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Treesitter
-- --------------------
-- Treesitter customizations are handled with AstroCore
-- as nvim-treesitter simply provides a download utility for parsers

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configuration of treesitter features in Neovim
    treesitter = {
      -- Globally enable or disable treesitter features
      -- can be:
      --   - a boolean
      --   - a function (`fun(lang: string, bufnr: integer): boolean`)
      enabled = function(lang, bufnr) return not require("astrocore.buffer").is_large(bufnr) end,
      -- Enable or disable treesitter based highlighting
      -- can be:
      --   - a boolean
      --   - a function (`fun(lang: string, bufnr: integer): boolean`)
      highlight = true,
      -- Enable or disable treesitter based indenting
      -- can be:
      --   - a boolean
      --   - a function (`fun(lang: string, bufnr: integer): boolean`)
      indent = true,
      -- List of treesitter parsers that should be installed automatically
      -- ("all" can be used to install all available parsers)
      ensure_installed = {
        -- Neovim core
        "lua",
        "vim",
        "vimdoc",

        -- General programming
        "bash",
        "python",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "json",
        "yaml",
        "rust",

        -- Extra languages you use
        "c",
        "cpp",
        "java",
        "scss",
        "sql",
        "jsonc",
        "regex",

        -- Markup & docs
        "markdown",
        "markdown_inline",

        -- Templates
        "htmldjango", -- Jinja/Django
        -- "jinja", -- buggy, doesn't show html templates

        -- Web frameworks
        "svelte",
        "vue",

        -- Optional languages
        "php",
        "latex",
        "typst",

        -- Utilities
        "csv",

        -- Less useful / niche (keep only if you use these)
        -- "llvm",
        -- "powershell",
        -- "ruby",
        -- "norg", -- snacks.image, broken on 0.12
      },
      -- Automatically detect missing treesitter parser and install when editing file
      auto_install = true,
      -- Configure treesitter based text objects (requires `nvim-treesitter-textobjects`)
      -- These options set up automatic detection of available queries for a file and creates
      -- only the available bindings for each buffer.
      textobjects = {
        select = {
          select_textobject = {
            ["af"] = { query = "@function.outer", desc = "around function" },
            ["if"] = { query = "@function.inner", desc = "around function" },
          },
        },
        move = {
          goto_next_start = {
            ["]f"] = { query = "@function.outer", desc = "Next function start" },
          },
          goto_next_end = {
            ["]F"] = { query = "@function.outer", desc = "Next function end" },
          },
          goto_previous_start = {
            ["[f"] = {
              query = "@function.outer",
              desc = "Previous function start",
            },
          },
          goto_previous_end = {
            ["[F"] = {
              query = "@function.outer",
              desc = "Previous function end",
            },
          },
        },
        swap = {
          swap_next = {
            [">F"] = { query = "@function.outer", desc = "Swap next function" },
          },
          swap_previous = {
            ["<F"] = {
              query = "@function.outer",
              desc = "Swap previous function",
            },
          },
        },
      },
    },
  },
}
