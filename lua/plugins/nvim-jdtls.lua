return {
  "mfussenegger/nvim-jdtls",
  opts = function(_, opts)
    opts.root_dir = vim.fs.root(0, {
      "pom.xml",
      "build.gradle",
      "build.gradle.kts",
      "settings.gradle",
      "settings.gradle.kts",
      ".git",
      "mvnw",
      "gradlew",
    })
    return opts
  end,
}
