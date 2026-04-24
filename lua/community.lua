-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE

-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  -- Base community repository
  "AstroNvim/astrocommunity",

  -- catppuccin color theme
  { import = "astrocommunity.colorscheme.catppuccin" },

  -- Specific community recipes (import these first)
  -- { import = "astrocommunity.recipes.auto-session-restore" },
  { import = "astrocommunity.recipes.vscode" },
  { import = "astrocommunity.recipes.heirline-vscode-winbar" },
  { import = "astrocommunity.recipes.picker-lsp-mappings" }, -- breaks otter

  -- Full community plugin pack (import after specific recipes)
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.cmake" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.cpp" },

  -- java
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.spring-boot" },

  { import = "astrocommunity.pack.html-css" }, -- includes json pack
  { import = "astrocommunity.pack.tailwindcss" },
  -- { import = "astrocommunity.pack.typescript-all-in-one" },

  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.python.basedpyright" },
  { import = "astrocommunity.pack.python.ruff" },

  { import = "astrocommunity.pack.prettier" },
  { import = "astrocommunity.pack.sql" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.toml" },

  -- Tools
  { import = "astrocommunity.pack.full-dadbod" },
  { import = "astrocommunity.pack.docker" },

  -- File explorer
  { import = "astrocommunity.file-explorer.yazi-nvim" },

  -- Git
  { import = "astrocommunity.git.codediff-nvim" },

  -- AI
  { import = "astrocommunity.ai.sidekick-nvim" },
  { import = "astrocommunity.ai.opencode-nvim" },
  -- { import = "astrocommunity.completion.copilot-lua-cmp" },

  -- Movement
  { import = "astrocommunity.motion.mini-surround" },
  { import = "astrocommunity.motion.marks-nvim" },

  -- Linting && Formatting
  { import = "astrocommunity.editing-support.conform-nvim" },
  { import = "astrocommunity.lsp.nvim-lint" },
  { import = "astrocommunity.editing-support.undotree" },

  -- Utility
  { import = "astrocommunity.editing-support.nvim-treesitter-context" },
  { import = "astrocommunity.editing-support.yanky-nvim" },
  { import = "astrocommunity.utility.live-preview" },
  { import = "astrocommunity.utility.noice-nvim" },
  { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },
  { import = "astrocommunity.search.grug-far-nvim" },

  -- Testing
  { import = "astrocommunity.test.neotest" },
  { import = "astrocommunity.test.nvim-coverage" },
  { import = "astrocommunity.code-runner.overseer-nvim" },
  { import = "astrocommunity.utility.lua-json5" },
  { import = "astrocommunity.diagnostics.trouble-nvim" },

  -- Debug
  -- Enable when debugging
  -- { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  -- { import = "astrocommunity.debugging.nvim-dap-repl-highlights" },
  -- { import = "astrocommunity.debugging.persistent-breakpoints-nvim" }, -- slow on startup

  -- -- You can also import/override your own plugins after community plugins
  -- -- { import = "your.plugins.override" },
}
