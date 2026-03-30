return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  -- lazy = true, -- disable for picker menu on startup
  dependencies = {
    "nvim-lua/plenary.nvim",
    "folke/snacks.nvim", -- disable for faster startup, together with config function
    -- "nvim-telescope/telescope.nvim", -- default setup
    { "AstroNvim/astroui", opts = { icons = { Harpoon = "󱡀" } } },
    {
      "AstroNvim/astrocore",
      opts = function(_, opts)
        local maps = opts.mappings
        local term_string = vim.fn.exists "$TMUX" == 1 and "tmux" or "term"
        local prefix = "<Leader><Leader>"

        maps.n[prefix] = { desc = require("astroui").get_icon("Harpoon", 1, true) .. "Harpoon and swaps" }

        maps.n[prefix .. "a"] = { function() require("harpoon"):list():add() end, desc = "Add file" }
        maps.n[prefix .. "e"] = {
          function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end,
          desc = "Toggle quick menu",
        }
        maps.n[prefix .. "x"] = {
          function()
            vim.ui.input({ prompt = "Harpoon mark index: " }, function(input)
              local num = tonumber(input)
              if num then require("harpoon"):list():select(num) end
            end)
          end,
          desc = "Goto index of mark",
        }
        maps.n["<C-p>"] = { function() require("harpoon"):list():prev() end, desc = "Goto previous mark" }
        maps.n["<C-n>"] = { function() require("harpoon"):list():next() end, desc = "Goto next mark" }

        -- if require("astrocore").is_available "telescope.nvim" then
        --   maps.n[prefix .. "m"] = { "<Cmd>Telescope harpoon marks<CR>", desc = "Show marks in Telescope" }
        -- end

        maps.n[prefix .. "m"] = {
          function()
            local harpoon = require "harpoon"
            local Snacks = require "snacks"
            Snacks.picker {
              finder = function()
                local items = {}
                for _, item in pairs(harpoon:list().items) do
                  if item then
                    items[#items + 1] = {
                      text = item.value,
                      file = item.value,
                    }
                  end
                end
                return items
              end,
              win = {
                input = {
                  keys = { ["dd"] = { "harpoon_delete", mode = { "n", "x" } } },
                },
                list = {
                  keys = { ["dd"] = { "harpoon_delete", mode = { "n", "x" } } },
                },
              },
              actions = {
                harpoon_delete = function(picker, item)
                  local to_remove = item or picker:selected()
                  if not to_remove then return end
                  harpoon:list():remove { value = to_remove.text }
                  picker:find { refresh = true }
                end,
              },
            }
          end,
          desc = "Harpoon Snacks Picker",
        }
      end,
    },
  },
}
