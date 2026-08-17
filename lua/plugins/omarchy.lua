local theme_file = vim.fn.expand "~/.local/state/omarchy/current/theme/neovim.lua"
local ok, theme_specs = pcall(dofile, theme_file)

if not ok or type(theme_specs) ~= "table" then return {} end

local colorscheme
local specs = {}

for _, spec in ipairs(theme_specs) do
  if type(spec) == "table" and spec[1] == "LazyVim/LazyVim" then
    colorscheme = spec.opts and spec.opts.colorscheme
  elseif type(spec) == "table" then
    specs[#specs + 1] = spec
  end
end

if colorscheme then
  specs[#specs + 1] = {
    "AstroNvim/astroui",
    opts = function(_, opts) opts.colorscheme = colorscheme end,
  }
end

return specs
