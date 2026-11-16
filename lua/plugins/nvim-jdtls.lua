local function jdtls_java()
  -- JDT LS 1.63 includes Eclipse bundles requiring Java 25, even though
  -- its core manifest and launcher still advertise Java 21.
  local minimum = 25
  local windows = vim.fn.has "win32" == 1
  local java = windows and "java.exe" or "java"
  local function from_home(home)
    if home and home ~= "" then return vim.fs.joinpath(home, "bin", java) end
  end
  local function compatible(executable)
    if not executable or vim.fn.executable(executable) ~= 1 then return false end
    local ok, process = pcall(vim.system, { executable, "-version" }, { text = true })
    if not ok then return false end
    local result = process:wait(3000)
    local version = tonumber(((result.stderr or "") .. (result.stdout or "")):match 'version%s+"(%d+)')
    return result.code == 0 and version ~= nil and version >= minimum
  end

  local override = from_home(vim.env.JDTLS_JAVA_HOME)
  if override then
    assert(compatible(override), "JDTLS_JAVA_HOME must point to a working Java 25+ JDK")
    return override
  end

  for _, executable in ipairs { from_home(vim.env.JAVA_HOME) or "", vim.fn.exepath(java) } do
    if compatible(executable) then return executable end
  end

  -- Discover a server JDK independently of the project's JAVA_HOME.
  local patterns = {
    "/usr/lib/jvm/*/bin/" .. java,
    vim.fn.expand "~" .. "/.local/share/mise/installs/java/*/bin/" .. java,
    "/Library/Java/JavaVirtualMachines/*/Contents/Home/bin/" .. java,
  }
  local program_files = vim.env.ProgramW6432 or vim.env.ProgramFiles
  if windows and program_files then
    patterns[#patterns + 1] = vim.fs.joinpath(program_files, "Microsoft", "jdk-*", "bin", java)
  end
  for _, pattern in ipairs(patterns) do
    for _, executable in ipairs(vim.fn.glob(pattern, false, true)) do
      if compatible(executable) then return executable end
    end
  end
  error "JDT LS requires Java 25+: install a compatible JDK and set JDTLS_JAVA_HOME"
end

return {
  "mfussenegger/nvim-jdtls",
  opts = function(_, opts)
    opts.cmd[1] = jdtls_java()
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
