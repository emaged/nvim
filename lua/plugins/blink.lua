-- lua/plugins/blink.lua
return {

  {
    "saghen/blink.compat",
    -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
    version = "*",
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  { -- override blink.cmp plugin
    "saghen/blink.cmp",
    opts = {
      -- your normal blink settings (optional)
      -- sources = { ... },
      keymap = {
        preset = "default",
        ["<CR>"] = false,
        ["<C-space>"] = false,
        ["<A-space>"] = { "show", "show_documentation", "hide_documentation" },
      },
      completion = {
        menu = {
          draw = {
            columns = {
              { "kind_icon" },
              { "label" },
              -- { "label", "label_description", gap = 1 },
              { "kind" },
            },
          },
          -- auto_show_delay_ms = 500,
        },
        list = {
          selection = {
            preselect = true, -- auto-select the first candidate
            auto_insert = true, -- keep this OFF unless you want auto-insertion on highlight
          },
        },
      },

      cmdline = {
        enabled = true,
        keymap = {
          preset = "cmdline",
          ["<Right>"] = false,
          ["<Left>"] = false,
        },
        completion = {
          list = { selection = { preselect = false } },
          menu = {
            auto_show = function(ctx) return vim.fn.getcmdtype() == ":" end,
          },
          ghost_text = { enabled = true },
        },
      },
      appearance = {
        -- sets the fallback highlight groups to nvim-cmp's highlight groups
        -- useful for when your theme doesn't support blink.cmp
        -- will be removed in a future release, assuming themes add support
        use_nvim_cmp_as_default = false,
        -- set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
        -- adjusts spacing to ensure icons are aligned
        nerd_font_variant = "mono",
      },
    },
  },

  {
    "catppuccin",
    optional = true,
    ---@type CatppuccinOptions
    opts = { integrations = { blink_cmp = true } },
  },
}
