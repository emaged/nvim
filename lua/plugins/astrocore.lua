-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        -- foo = "fooscript",
      },
      filename = {
        -- [".foorc"] = "fooscript",
      },
      pattern = {
        -- [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        mouse = "nvi",
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        scrolloff = 4,
        sidescrolloff = 8,
        wrap = false, -- sets vim.opt.wrap
        exrc = true,
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },
        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,

        -- astro reload
        ["<Leader>pA"] = { "<cmd>AstroReload<cr>", desc = "AstroReload, experimental!" },
        --reload package
        ["<Leader>pl"] = { ":Lazy reload ", desc = "Reload package" },
        -- CodeDiff command
        ["<Leader>gD"] = { "<cmd>CodeDiff<cr>", desc = "View CodeDiff diff" },
        -- Dadbod UI open
        ["<Leader>D"] = { "<cmd>DBUI<cr>", desc = "Dadbod UI" },

        -- snacks picker additional mappings
        ["<Leader>fe"] = { function() require("snacks").picker.explorer() end, desc = "File Explorer" },
        ["<Leader>f:"] = { function() require("snacks").picker.command_history() end, desc = "Command History" },
        ["<Leader>fP"] = { function() require("snacks").picker.lazy() end, desc = "Search for Plugin Spec" },

        -- aerial symbol opener
        ["<Leader>fS"] = { function() require("aerial").open() end, desc = "Open Aerial" },

        -- smart-splits swap buffers
        ["<Leader><Leader>h"] = { function() require("smart-splits").swap_buf_left() end, desc = "Swap left split" },
        ["<Leader><Leader>j"] = { function() require("smart-splits").swap_buf_down() end, desc = "Swap below split" },
        ["<Leader><Leader>k"] = { function() require("smart-splits").swap_buf_up() end, desc = "Swap above split" },
        ["<Leader><Leader>l"] = { function() require("smart-splits").swap_buf_right() end, desc = "Swap right split" },

        -- Noice group for <Leader>N
        ["<Leader>N"] = { desc = " Noice" },
        -- snipRun group
        ["<Leader>r"] = { desc = "󰜎 Run (SnipRun)" },
        -- multicursor group
        ["<Leader>m"] = { desc = "󰗧 Multicursor" },
        -- Otter group
        ["<Leader>I"] = { desc = "󰐗 Otter Inject" },
        -- Obsidian group
        ["<Leader>V"] = { desc = "󱓞 Obsidian" },
        -- debugprint group
        ["g?"] = { desc = "󰍉 Debugprint" },
      },
      x = {
        -- groups
        ["<Leader>r"] = { desc = "󰜎 Run (SnipRun)" },
        ["<Leader>,"] = { desc = "󰗧 Multicursor" },
        ["g?"] = { desc = "󰍉 Debugprint" },

        -- grug-far keybinds
        ["<Leader>s"] = { desc = "󰛔 Search/Replace" },
        ["<Leader>sr"] = { function() require("grug-far").open() end, desc = "Replace selection" },
        ["<Leader>si"] = {
          function() require("grug-far").open { visualSelectionUsage = "operate-within-range" } end,
          desc = "Search inside selection",
        },
      },
    },
  },
}
