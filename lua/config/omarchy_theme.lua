local M = {}
local current = vim.fn.expand "~/.local/state/omarchy/current"
local base_opts = {}
local retained = {}
local watcher
local generation = 0

local function notify(message) vim.notify("Omarchy: " .. message, vim.log.levels.WARN) end

local function name(spec) return spec.name or spec[1]:gsub("%.git$", ""):match "[^/]+$" end

local function options(spec, plugin, base)
  local opts = vim.deepcopy(base or {})
  if type(spec.opts) == "function" then return spec.opts(plugin, opts) or opts end
  return vim.tbl_deep_extend("force", opts, spec.opts or {})
end

-- Keep native theme plugins declared for this session, including after Lazy
-- reparses the configuration. Retain identities, not a previous theme's options.
local function identity(spec)
  if type(spec) == "string" then spec = { spec } end
  local result = { spec[1], name = spec.name, dir = spec.dir, lazy = true }
  if spec.dependencies then
    result.dependencies = {}
    for _, dependency in ipairs(spec.dependencies) do
      result.dependencies[#result.dependencies + 1] = identity(dependency)
    end
  end
  return result
end

local function remember(specs)
  for _, spec in ipairs(specs) do
    retained[name(spec)] = identity(spec)
  end
end

local function setup_aether(_, opts)
  local hotreload = require "aether.hotreload"
  if not hotreload.omarchy_native then
    local setup = hotreload.setup
    hotreload.setup = function(...)
      setup(...)
      -- The installed Aether has no watcher opt-out. Its shared state exposes
      -- handles by path; close only Omarchy handles, keeping Aether CLI/dev reloads.
      local state = rawget(_G, "__aether_hotreload_state")
      if not state then return end
      local roots = { vim.fn.expand "~/.config/omarchy", vim.fn.expand "~/.local/state/omarchy" }
      for _, handles in ipairs { state.fs_event_handles or {}, state.pending_reload_timers or {} } do
        for path, handle in pairs(handles) do
          for _, root in ipairs(roots) do
            if path == root or vim.startswith(path, root .. "/") then
              if not handle:is_closing() then
                handle:stop()
                handle:close()
              end
              handles[path] = nil
              break
            end
          end
        end
      end
    end
    hotreload.omarchy_native = true
  end
  require("aether").setup(opts)
end

local aether_spec = { "bjarneo/aether.nvim", optional = true, config = setup_aether }

function M.read()
  local ok, specs = pcall(dofile, current .. "/theme/neovim.lua")
  if not ok then return nil, specs end
  if type(specs) ~= "table" then return nil, "neovim.lua must return a table" end

  local plugins, colorscheme = {}, nil
  for _, spec in ipairs(specs) do
    if type(spec) == "table" and spec[1] == "LazyVim/LazyVim" then
      colorscheme = spec.opts and spec.opts.colorscheme
    elseif type(spec) == "table" then
      plugins[#plugins + 1] = spec
    end
  end
  if type(colorscheme) ~= "string" then return nil, "neovim.lua has no native colorscheme" end
  return { plugins = plugins, colorscheme = colorscheme }
end

-- Keep the options supplied by AstroCommunity/user specs separate from the
-- current theme, so switching away also drops the previous theme's options.
function M.specs(theme)
  remember(theme.plugins)
  local specs = vim.deepcopy(theme.plugins)
  for _, spec in ipairs(specs) do
    if spec.opts ~= nil then
      local original = vim.deepcopy(spec)
      spec.opts = function(plugin, opts)
        base_opts[plugin.name] = vim.deepcopy(opts)
        return options(original, plugin, opts)
      end
    end
  end
  table.insert(specs, 1, {
    name = "omarchy-session-themes",
    import = function() return vim.deepcopy(vim.tbl_values(retained)) end,
  })
  specs[#specs + 1] = vim.deepcopy(aether_spec)
  return specs
end

local function apply(theme)
  local config = require "lazy.core.config"
  local plugin = require "lazy.core.plugin"
  local loader = require "lazy.core.loader"
  -- Normalize names and dependencies using the installed lazy.nvim version.
  local resolved = plugin.Spec.new({ theme.plugins, vim.deepcopy(aether_spec) }, { pkg = false })
  if #resolved.notifs > 0 then error(resolved.notifs[1].msg) end

  -- Check every dependency before changing the active colorscheme. Never install
  -- plugins from the watcher or rerun the full Neovim configuration.
  for key, candidate in pairs(resolved.plugins) do
    local installed = config.plugins[key] or candidate
    if not vim.uv.fs_stat(installed.dir) then
      error(key .. " is not installed; restart Neovim with this theme and install it through Lazy")
    end
  end
  local added = {}
  for key in pairs(resolved.plugins) do
    if not config.plugins[key] then added[#added + 1] = key end
  end
  for _, spec in ipairs(theme.plugins) do
    local key = name(spec)
    if not base_opts[key] then
      base_opts[key] = config.plugins[key] and vim.deepcopy(plugin.values(config.plugins[key], "opts", false)) or {}
    end
  end
  remember(theme.plugins)
  if #added > 0 then
    -- Register actual spec fragments instead of inserting ad hoc plugin objects.
    config.spec:parse(vim.deepcopy { theme.plugins, aether_spec })
    config.plugins = config.spec.plugins
    plugin.update_state() -- also removes registered plugins from the cleanup list
    for _, key in ipairs(added) do
      local installed = assert(config.plugins[key])
      if type(installed.init) == "function" then installed.init(installed) end
    end
  end

  for _, spec in ipairs(theme.plugins) do
    local installed = assert(config.plugins[name(spec)])
    local opts = options(spec, installed, base_opts[installed.name])
    if spec.config ~= nil then installed.config = spec.config end
    if spec.main then installed.main = spec.main end
    if spec.opts ~= nil or installed.opts ~= nil then
      -- Replace (rather than merge) cached options so old theme settings vanish.
      installed.opts = function() return vim.deepcopy(opts) end
      installed._.cache = nil
    end
    if not installed._.loaded then
      require("lazy").load { plugins = { installed.name } }
    elseif installed.config or installed.opts then
      loader.config(installed)
    end
  end
  -- Match a fresh startup: generic schemes such as catppuccin-nvim otherwise
  -- inherit "light" from the previous theme. Explicit light schemes set it again.
  local previous, background = vim.g.colors_name, vim.o.background
  vim.g.colors_name = nil
  vim.o.background = "dark"
  -- Native themes use this to decide whether to clear the previous highlights.
  vim.g.colors_name = previous
  local ok, err = pcall(vim.cmd.colorscheme, theme.colorscheme)
  if not ok then
    vim.o.background = background
    vim.g.colors_name = previous
    error(err)
  end
end

function M.reload()
  local ok, err = pcall(function()
    local theme, read_error = M.read()
    if not theme then error(read_error) end
    apply(theme)
  end)
  if not ok then notify(tostring(err)) end
end

function M.stop()
  generation = generation + 1
  if watcher then
    watcher:stop()
    watcher:close()
    watcher = nil
  end
end

function M.start()
  M.stop()
  if not vim.uv.fs_stat(current .. "/theme.name") then return end
  local err
  watcher, err = vim.uv.new_fs_event()
  if not watcher then return notify(tostring(err)) end
  -- Watch the parent directory: this survives replacement of theme.name as
  -- well as Omarchy's replacement of the entire theme directory.
  local ok
  ok, err = watcher:start(current, {}, function(event_error, filename)
    if event_error then
      vim.schedule(function() notify(tostring(event_error)) end)
    elseif filename == "theme.name" then
      generation = generation + 1
      local pending = generation
      vim.schedule(function()
        vim.defer_fn(function()
          if watcher and pending == generation then M.reload() end
        end, 100)
      end)
    end
  end)
  if not ok then
    M.stop()
    return notify(tostring(err))
  end
  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("OmarchyNativeTheme", { clear = true }),
    callback = M.stop,
  })
end

return M
