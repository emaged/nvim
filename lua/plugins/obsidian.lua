return {
  "obsidian-nvim/obsidian.nvim",
  -- version = "*", -- recommended, use latest release instead of latest commit
  -- ft = "markdown",
  -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
  -- event = {
  --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
  --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
  --   -- refer to `:h file-pattern` for more examples
  --   "BufReadPre path/to/my-vault/*.md",
  --   "BufNewFile path/to/my-vault/*.md",
  -- },
  event = { "BufReadPre */Dropbox/Vault/*.md" },
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "AstroNvim/astrocore",
      opts = {
        mappings = {
          n = {

            -- ========= OPEN / NAVIGATION =========
            ["<Leader>Vo"] = { "<Cmd>Obsidian open<CR>", desc = "Obsidian Open in App" },
            ["<Leader>Vs"] = { "<Cmd>Obsidian search<CR>", desc = "Obsidian Search Notes" },
            ["<Leader>Vq"] = { "<Cmd>Obsidian quick_switch<CR>", desc = "Obsidian Quick Switch" },
            ["<Leader>Vb"] = { "<Cmd>Obsidian backlinks<CR>", desc = "Obsidian Backlinks" },
            ["<Leader>VL"] = { "<Cmd>Obsidian links<CR>", desc = "Obsidian Buffer Links" },

            -- ========= NEW NOTES =========
            ["<Leader>Vnn"] = { "<Cmd>Obsidian new<CR>", desc = "Obsidian New Note" },
            ["<Leader>Vnt"] = { "<Cmd>Obsidian new_from_template<CR>", desc = "New Note From Template" },

            -- ========= DAILY NOTES =========
            ["<Leader>Vdt"] = { "<Cmd>Obsidian today<CR>", desc = "Today's Note" },
            ["<Leader>Vdy"] = { "<Cmd>Obsidian yesterday<CR>", desc = "Yesterday's Note" },
            ["<Leader>Vdm"] = { "<Cmd>Obsidian tomorrow<CR>", desc = "Tomorrow's Note" },
            ["<Leader>Vdl"] = { "<Cmd>Obsidian dailies<CR>", desc = "List Daily Notes" },

            -- ========= LINKS =========
            ["<Leader>Vlf"] = { "<Cmd>Obsidian follow_link<CR>", desc = "Follow Link" },

            -- ========= TAGS / TOC / TEMPLATES =========
            ["<Leader>Vtt"] = { "<Cmd>Obsidian tags<CR>", desc = "Search Tags" },
            ["<Leader>VtT"] = { "<Cmd>Obsidian template<CR>", desc = "Insert Template" },
            ["<Leader>Vtc"] = { "<Cmd>Obsidian toc<CR>", desc = "Table of Contents" },

            -- ========= WORKSPACE =========
            ["<Leader>Vw"] = { "<Cmd>Obsidian workspace<CR>", desc = "Switch Workspace" },

            -- ========= UTILITIES =========
            ["<Leader>Vr"] = { "<Cmd>Obsidian rename<CR>", desc = "Rename Note" },
            ["<Leader>Vc"] = { "<Cmd>Obsidian toggle_checkbox<CR>", desc = "Toggle Checkbox" },
            ["<Leader>Vp"] = { "<Cmd>Obsidian paste_img<CR>", desc = "Paste Image" },

            -- ========= SMART GF =========
            ["gf"] = {
              function()
                if require("obsidian").util.cursor_on_markdown_link() then
                  return "<Cmd>Obsidian follow_link<CR>"
                else
                  return "gf"
                end
              end,
              expr = true,
              desc = "Obsidian Follow Link",
            },
          },

          v = {
            -- ========= VISUAL MODE =========
            ["<Leader>Vl"] = { ":Obsidian link<CR>", desc = "Link Selection" },
            ["<Leader>Vn"] = { ":Obsidian link_new<CR>", desc = "New Note from Selection" },
            ["<Leader>Ve"] = { ":Obsidian extract_note<CR>", desc = "Extract Note" },
          },
        },
      },
    },
  },
  opts = function(_, opts)
    local astrocore = require "astrocore"
    return astrocore.extend_tbl(opts, {
      legacy_commands = false, -- this will be removed in the next major release
      ui = { enable = false },

      workspaces = {
        {
          path = vim.env.HOME .. "/Dropbox/Vault", -- specify the vault location. no need to call 'vim.fn.expand' here
        },
      },
      open = {
        use_advanced_uri = true,
      },
      finder = (astrocore.is_available "snacks.pick" and "snacks.pick")
        or (astrocore.is_available "telescope.nvim" and "telescope.nvim")
        or (astrocore.is_available "fzf-lua" and "fzf-lua")
        or (astrocore.is_available "mini.pick" and "mini.pick"),

      templates = {
        subdir = "templates",
        date_format = "%Y-%m-%d-%a",
        time_format = "%H:%M",
      },
      daily_notes = {
        folder = "daily",
      },
      completion = {
        nvim_cmp = astrocore.is_available "nvim-cmp",
        blink = astrocore.is_available "blink",
      },

      frontmatter = { -- ai version
        func = function(note)
          local out = { id = note.id, aliases = note.aliases, tags = note.tags }
          if note.metadata ~= nil and not vim.tbl_isempty(note.metadata) then
            for k, v in pairs(note.metadata) do
              out[k] = v
            end
          end
          return out
        end,
      },

      -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
      -- URL it will be ignored but you can customize this behavior here.
      -- follow_url_func = vim.ui.open, -- deprecated
    })
  end,
  ---@module 'obsidian'
  ---@type obsidian.config
  -- opts = {
  --   legacy_commands = false, -- this will be removed in the next major release
  --   ui = { enable = false },
  --
  --   workspaces = {
  --     {
  --       name = "work",
  --       path = "~/Dropbox/Vault",
  --     },
  --   },
  --   -- see below for full list of options 👇
  -- },
  -- run before the plugin loads to block its LSP
  init = function()
    package.loaded["obsidian.lsp"] = nil
    package.preload["obsidian.lsp"] = function()
      return { start = function() return nil end }
    end
  end,
}
