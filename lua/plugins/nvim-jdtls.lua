return {
  "mfussenegger/nvim-jdtls",
  opts = function(_, opts)
    -- JDT LS relies on client watchers for Java sources and Maven/Gradle metadata.
    opts.capabilities = vim.tbl_deep_extend("force", opts.capabilities or {}, {
      workspace = { didChangeWatchedFiles = { dynamicRegistration = true } },
    })
    opts.root_dir = vim.fs.root(0, {
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
    return opts
  end,
}
