local specs = {
  {
    "AstroNvim/astrocore",
    -- Run before clipboard use, even without an Omarchy theme on this machine.
    init = function() require("config.remote_clipboard").setup() end,
  },
}

local omarchy = require "config.omarchy_theme"
local theme = omarchy.read()

if not theme then return specs end

vim.list_extend(specs, omarchy.specs(theme))

specs[#specs + 1] = {
  "AstroNvim/astroui",
  opts = function(_, opts) opts.colorscheme = theme.colorscheme end,
}
specs[#specs + 1] = {
  "AstroNvim/astrocore",
  opts = {
    autocmds = {
      omarchy_native_theme = {
        { event = "User", pattern = "VeryLazy", callback = omarchy.start },
      },
    },
  },
}

return specs
