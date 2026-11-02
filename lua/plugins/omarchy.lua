local omarchy = require "config.omarchy_theme"
local theme = omarchy.read()

if not theme then return {} end

local specs = omarchy.specs(theme)

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
