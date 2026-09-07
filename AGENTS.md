# Neovim configuration

## Structure

- This configuration uses AstroNvim ^6 and lazy.nvim.
- `init.lua` bootstraps lazy.nvim and loads the configuration modules.
- `lua/lazy_setup.lua` configures AstroNvim and imports community and plugin specs.
- Use `lua/plugins/` for custom plugin specs and `lua/community.lua` for
  AstroCommunity imports.
- Inspect `lua/keymaps.lua`, `lua/commands.lua`, and `lua/polish.lua` for existing
  customizations before adding equivalent behavior elsewhere.

## Changes and documentation

- Keep changes focused and follow neighboring plugin-spec conventions.
- Consult official documentation matching the installed plugin version when
  options or behavior are uncertain. Use `lazy-lock.json` to identify revisions.
- Prefer documented defaults unless customization is requested.
- Do not invent plugin options or APIs.
- Avoid changing bootstrap code or updating plugins and `lazy-lock.json`
  unless required by the requested task.
- Cite documentation briefly when it determines an implementation choice.

## Verification

- Follow `.stylua.toml` for formatting and `selene.toml` for lint conventions.
- The README does not currently document an automated test command.
  Derive focused checks from the configuration and identify them as inferred.
- Report which checks ran and their results; identify checks not run separately.
- Starting Neovim can bootstrap lazy.nvim and trigger plugin setup.
  Describe these side effects when proposing startup checks.
- For interactive changes, explain what to check in Neovim and distinguish
  completed checks from checks the user still needs to perform.
