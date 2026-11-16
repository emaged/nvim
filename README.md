# AstroNvim Template

**NOTE:** This is for AstroNvim v5+

A template for getting started with [AstroNvim](https://github.com/AstroNvim/AstroNvim)

## 🛠️ Installation

#### Make a backup of your current nvim and shared folder

```shell
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

#### Create a new user repository from this template

Press the "Use this template" button above to create a new repository to store your user configuration.
hello
You can also just clone this repository directly if you do not want to track your user configuration in GitHub.

#### Clone the repository

```shell
git clone https://github.com/<your_user>/<your_repository> ~/.config/nvim
```

#### Start Neovim

```shell
nvim
```

## Java runtime

The installed JDT LS 1.63 distribution includes Eclipse components requiring
**Java 25 or newer**, even though its core manifest and launcher still declare
Java 21. The runtime check therefore requires Java 25+.

Set `JDTLS_JAVA_HOME` to explicitly choose the language server's JDK. An invalid
or older override produces an actionable error. Otherwise, the configuration
tries `JAVA_HOME`, `java` on `PATH`, and installed JDKs under `/usr/lib/jvm`, the
standard mise Java directory, and macOS's `JavaVirtualMachines` directory,
skipping runtimes older than Java 25. Windows uses `java.exe` and also searches
Microsoft JDK installations under `Program Files`, including the Java 25 JDK
installed by the Windows bootstrap. Nonstandard installations can use
`JDTLS_JAVA_HOME`, `JAVA_HOME`, or `PATH`.

The language server's runtime is independent of the project's target JDK, so
your shell and projects can continue using an older Java version.
