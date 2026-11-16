return {
  "mfussenegger/nvim-lint",
  opts = {
    linters_by_ft = {
      lua = { "selene" },
      html = { "htmlhint" },
      htmldjango = { "djlint" },
      jinja = { "djlint" },
      ["jinja.html"] = { "djlint" },
    },
    linters = {
      selene = {
        cmd = "selene",
        stdin = true, -- use stdin; nvim-lint will pipe the current buffer
        args = {
          -- first arg: config flag if found, otherwise a harmless fallback flag
          function()
            local filename = vim.api.nvim_buf_get_name(0)
            local config = vim.fs.find("selene.toml", {
              path = vim.fs.dirname(filename),
              upward = true,
              type = "file",
            })[1]
            if config then return "--config=" .. config end
            -- Keep a valid argument when no project config exists.
            return "--no-summary"
          end,
          "--display-style",
          "json",
          "-", -- read from stdin
        },
        stream = "stdout",
        ignore_exitcode = true,
      },
    },
  },
}
