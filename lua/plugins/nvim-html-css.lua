-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
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
      "typescript",
      "typescriptreact",
      "erb",
      "svelte",
      "vue",
      "blade",
      "php",
      "templ",
      "astro",
    },
    dependencies = { "saghen/blink.cmp", "nvim-treesitter/nvim-treesitter" }, -- Use this if you're using blink.cmp
    -- Keep upstream's implementation, but require trust before loading project Lua.
    config = function(plugin, opts)
      local chunk = assert(loadfile(plugin.dir .. "/lua/html-css/init.lua"))
      setfenv(chunk, setmetatable({
        dofile = function(path)
          local source = vim.secure.read(path)
          if type(source) == "string" then return assert(loadstring(source, "@" .. path))() end
        end,
      }, { __index = _G }))
      local html_css = chunk()
      package.loaded["html-css"] = html_css
      html_css.setup(opts)
    end,
    opts = {
      enable_on = { -- Example file types
        "html",
        "htmldjango",
        "jinja.html",
        "jinja",
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
      handlers = {
        definition = {
          bind = "gd",
        },
        hover = {
          bind = "K",
          wrap = true,
          border = "rounded",
          position = "cursor",
        },
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
