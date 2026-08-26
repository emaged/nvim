return {
  {
    "folke/snacks.nvim",
    init = function(plugin)
      package.preload["snacks.image.terminal"] = function()
        local path = plugin.dir .. "/lua/snacks/image/terminal.lua"
        local source = table.concat(vim.fn.readfile(path), "\n")
        local old = 'vim.trim(out):find(" on$")'
        local new = '(vim.trim(out):find(" on$") or vim.trim(out):find(" always$"))'
        local first, last = source:find(old, 1, true)

        if first then source = source:sub(1, first - 1) .. new .. source:sub(last + 1) end

        return assert(load(source, "@" .. path))()
      end
    end,
    opts = {
      picker = {
        sources = {
          files = {
            exclude = {
              "__pycache__",
              ".venv",
              "venv",
              "node_modules",
            },
          },
          --   explorer = {
          --     exclude = {
          --       "__pycache__",
          --       ".venv",
          --       "venv",
          --     },
          --   },
        },
      },
    },
  },
}
