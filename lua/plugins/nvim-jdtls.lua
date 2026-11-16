return {
  "mfussenegger/nvim-jdtls",
  opts = function(_, opts)
    -- JDT LS relies on client watchers for Java sources and Maven/Gradle metadata.
    opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, {
      workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
    })
  end,
  config = function(_, opts)
    local group = vim.api.nvim_create_augroup("java-project-lsp", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = "java",
      callback = function(args)
        -- Lazy caches opts once; the root and JDT LS workspace must be chosen
        -- again for each buffer, including projects opened later in the session.
        local root = vim.fs.root(args.buf, {
          "pom.xml",
          "build.gradle",
          "build.gradle.kts",
          "settings.gradle",
          "settings.gradle.kts",
          ".git",
          "mvnw",
          "gradlew",
          ".lift",
        })
        if not root then
          return require("astrocore").notify("jdtls: no Java project root found", vim.log.levels.WARN)
        end
        local config = vim.deepcopy(opts)
        config.root_dir = root
        local workspace = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. vim.fn.sha256(root)
        for i, arg in ipairs(config.cmd) do
          if arg == "-data" then config.cmd[i + 1] = workspace end
        end
        require("jdtls").start_or_attach(config)
      end,
    })
    -- Preserve AstroCommunity's debugger setup after JDT LS attaches.
    vim.api.nvim_create_autocmd("LspAttach", {
      group = group,
      pattern = "*.java",
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "jdtls" then require("jdtls.dap").setup_dap_main_class_configs() end
      end,
    })
  end,
}
