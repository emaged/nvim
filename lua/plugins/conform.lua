return {
  "stevearc/conform.nvim",
  opts = {
    formatters = {
      -- Use the buffer width as a fallback; project configuration takes precedence.
      prettierd = {
        append_args = function(_, ctx) return { "--tab-width=" .. ctx.shiftwidth, "--config-precedence=file-override" } end,
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
