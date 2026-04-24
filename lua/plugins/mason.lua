-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- Customize Mason

---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = function(_, opts)
      -- Make sure to use the names found in `:Mason`
      require("astrocore").list_insert_unique(opts.ensure_installed, {
        -- install language servers
        "basedpyright",
        "bash-language-server",
        "clangd",
        "django-template-lsp",
        "html-lsp",
        "css-lsp",
        -- "css-variables-language-server",
        -- "cssmodules-language-server",
        "eslint-lsp",
        "emmet-language-server",
        "vtsls",
        -- "tailwindcss-language-server",
        -- "vue-language-server",
        "jinja-lsp",
        "jdtls",
        "json-lsp",
        "some-sass-language-server",
        "stylelint-language-server",
        "sqlls",
        -- "pyrefly",
        "rust-analyzer",

        -- install formatters && linters
        "stylua",
        "clang-format",
        "djlint",
        -- "eslint_d",
        "htmlhint",
        "jsonlint",
        "prettier",
        "prettierd",
        "ruff",
        "selene",
        "shfmt", -- bash formatter
        "shellcheck", -- bash linter
        -- "stylelint", -- enabled as lsp
        "sql-formatter",
        "sqlfluff",
        "hadolint",

        -- install debuggers
        "debugpy",

        -- install any other package
        "tree-sitter-cli",
        --"copilot-language-server",

        -- spellcheck
        "codebook",
        "harper-ls",
      })
    end,
  },
}
