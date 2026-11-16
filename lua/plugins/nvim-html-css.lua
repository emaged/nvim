return {
  {
    "Jezda1337/nvim-html-css",
    ft = {
      "html",
      "htmldjango",
      "jinja",
      "jinja.html",
      "javascript",
      "javascriptreact",
      "typescriptreact",
      "eruby",
      "svelte",
      "vue",
      "blade",
      "php",
      "templ",
      "astro",
    },
    dependencies = {
      "saghen/blink.cmp",
      "nvim-treesitter/nvim-treesitter",
      "AstroNvim/astrolsp",
    },
    config = function(plugin, opts) require("config.html_css").setup(plugin, opts) end,
    opts = {
      enable_on = { -- Filename extensions, unlike Lazy's `ft` list above.
        "html",
        "htm",
        "htmldjango",
        "jinja",
        "j2",
        "js",
        "tsx",
        "jsx",
        "erb",
        "svelte",
        "vue",
        "blade",
        "php",
        "templ",
        "astro",
      },
      documentation = {
        auto_show = true,
      },
      style_sheets = {
        -- "https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css",
        -- "https://cdnjs.cloudflare.com/ajax/libs/bulma/1.0.3/css/bulma.min.css",
        -- "./index.css", -- `./` refers to the current working directory.
      },
    },
  },
}
