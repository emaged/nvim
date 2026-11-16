return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      -- Follow the buffer width selected by EditorConfig, including template paths.
      prettierd = {
        append_args = function(_, ctx) return { "--tab-width=" .. ctx.shiftwidth } end,
      },
      djlint = {
        prepend_args = function(_, ctx)
          local width = tostring(ctx.shiftwidth)
          return { "--indent", width, "--format-js", "--indent-js", width }
        end,
      },
    },
    formatters_by_ft = {
      css = { "prettierd" },
      html = { "prettierd" },
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
      json = { "prettierd" },
      lua = { "stylua" },
      htmldjango = { "djlint" },
      sql = { "sqlfluff" },
    },
  },
}
