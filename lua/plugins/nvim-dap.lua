local function get_python_path()
  -- 1) Activated venv
  if vim.env.VIRTUAL_ENV then return vim.env.VIRTUAL_ENV .. "/bin/python" end

  -- 2) Project venv
  local cwd = vim.fn.getcwd()
  if vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
    return cwd .. "/.venv/bin/python"
  elseif vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
    return cwd .. "/venv/bin/python"
  end

  -- 3) System python
  if vim.fn.executable "python3" == 1 then
    return "python3"
  elseif vim.fn.executable "python" == 1 then
    return "python"
  end

  -- 4) Last resort
  return "/usr/bin/python3"
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "jbyuki/one-small-step-for-vimkind",
        keys = {
          {
            "<Leader>dl",
            function() require("osv").launch { port = 8086 } end,
            desc = "Launch Lua adapter",
          },
        },
      },
      {
        "mfussenegger/nvim-dap-python",
        lazy = true,
        ft = false,
      },
    },
    opts = function(_, _)
      local dap = require "dap"
      -----------------------
      -- PYTHON
      -----------------------
      dap.configurations.python = dap.configurations.python or {}

      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Django: runserver",
        program = "${workspaceFolder}/manage.py",
        args = { "runserver", "--noreload" },
        console = "integratedTerminal",
        django = true,
        pythonPath = get_python_path,
      })

      table.insert(dap.configurations.python, {
        type = "python",
        request = "launch",
        name = "Pytest: current file",
        module = "pytest",
        args = { "${file}" },
        console = "integratedTerminal",
        pythonPath = get_python_path,
      })

      -----------------------
      -- C / C++ / RUST
      -----------------------
      dap.configurations.cpp = dap.configurations.cpp or {}

      table.insert(dap.configurations.cpp, {
        name = "Attach to gdbserver",
        type = "codelldb",
        request = "attach",
        cwd = "${workspaceFolder}",
        connect = function()
          local host = vim.fn.input "gdbserver host [localhost]: "
          if host == "" then host = "localhost" end
          local port = vim.fn.input "gdbserver port: "
          return { host = host, port = tonumber(port) }
        end,
        program = function() return vim.fn.input("Path to local binary: ", vim.fn.getcwd() .. "/tests", "file") end,
      })

      dap.configurations.c = dap.configurations.cpp
      -- dap.configurations.rust = dap.configurations.rust or dap.configurations.cpp

      -----------------------
      -- LUA
      -----------------------
      dap.adapters.nlua = function(callback, config)
        callback { type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 }
      end
      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
        },
      }
    end,
  },
}
