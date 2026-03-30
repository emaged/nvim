return {
  {
    "nvim-neotest/neotest",
    opts = function(_, opts)
      -- for new adapters not in astrocommunity
      -- opts.adapters = opts.adapters or {}
      -- table.insert(
      --   opts.adapters,
      --   require "neotest-python" {
      --     dap = { justMyCode = false },
      --     args = { "--log-level", "DEBUG" },
      --     runner = "pytest",
      --     python = ".venv/bin/python",
      --     pytest_discover_instances = true,
      --   }
      -- )

      -- 👇 THIS replaces require("neotest").setup(...)
      opts.consumers = opts.consumers or {}
      opts.consumers.overseer = require "neotest.consumers.overseer"
    end,
  },
  -- override astrocommunity settings like this
  {
    "nvim-neotest/neotest-python",
    lazy = true,
    opts = {
      dap = { justMyCode = false },
      args = {
        "--log-level",
        "DEBUG",

        -- coverage: requires python -m pip install pytest-cov
        "--cov=.", -- or "--cov=myapp" for a single app
        -- optionally:
        -- "--cov-report=html:htmlcov",
      },
      runner = "pytest",
      python = "python",
      pytest_discover_instances = true,

      is_test_file = function(file)
        return file:match "tests%.py$" or file:match "test_.*%.py$" or file:match ".*_test%.py$"
      end,
      django = true,
    },
  },
}
