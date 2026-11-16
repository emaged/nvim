local M = {}

function M.setup(plugin, opts)
  local handlers, attached = {}, {}
  local filetypes = {}
  for _, ft in ipairs(plugin.ft) do
    filetypes[ft] = true
  end

  -- The upstream handlers expose setup(), which installs a mapping. Give only
  -- those modules buffer-local setters; keep their CSS lookup and LSP fallbacks.
  local handler_vim = setmetatable({
    opt = vim.opt_local,
    keymap = setmetatable({
      set = function(mode, lhs, rhs, map_opts)
        vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", map_opts or {}, { buffer = true }))
      end,
    }, { __index = vim.keymap }),
  }, { __index = vim })

  local function load_handler(name)
    local module_name = "html-css." .. name
    local chunk = assert(loadfile(plugin.dir .. "/lua/html-css/" .. name .. ".lua"))
    setfenv(chunk, setmetatable({ vim = handler_vim }, { __index = _G }))
    local handler = chunk()
    package.loaded[module_name] = handler
    return {
      setup = function(handler_opts) handlers[name] = { module = handler, opts = handler_opts } end,
    }
  end

  local chunk = assert(loadfile(plugin.dir .. "/lua/html-css/init.lua"))
  setfenv(
    chunk,
    setmetatable({
      -- Preserve the trust check for project-specific .nvim.lua files.
      dofile = function(path)
        local source = vim.secure.read(path)
        if type(source) == "string" then return assert(loadstring(source, "@" .. path))() end
      end,
      require = function(name)
        if name == "html-css.definition" then return load_handler "definition" end
        if name == "html-css.hover" then return load_handler "hover" end
        return require(name)
      end,
    }, { __index = _G })
  )
  local html_css = chunk()
  package.loaded["html-css"] = html_css
  html_css.setup(opts)

  local function configure_buffer(bufnr)
    if not vim.api.nvim_buf_is_loaded(bufnr) then return end
    local active = filetypes[vim.bo[bufnr].filetype] and vim.bo[bufnr].buftype == ""
    if not active and not attached[bufnr] then return end

    vim.api.nvim_buf_call(bufnr, function()
      local state = attached[bufnr]
      if not active then
        for lhs, map in pairs(state.maps) do
          local current = vim.fn.maparg(lhs, "n", false, true)
          if current.buffer == 1 and current.callback == map.callback then
            vim.keymap.del("n", lhs, { buffer = bufnr })
            if map.before.buffer == 1 then vim.fn.mapset("n", false, map.before) end
          end
        end
        if vim.bo.iskeyword == state.keyword_after then vim.bo.iskeyword = state.keyword_before end
        vim.b.html_css_keymaps = nil
        attached[bufnr] = nil
        return
      end

      state = state or { maps = {}, keyword_before = vim.bo.iskeyword }
      if state.keyword_after and vim.bo.iskeyword ~= state.keyword_after then
        state.keyword_before = vim.bo.iskeyword
      end
      attached[bufnr] = state
      local keys = {}
      for _, handler in pairs(handlers) do
        local lhs = handler.opts.bind
        state.maps[lhs] = state.maps[lhs] or { before = vim.fn.maparg(lhs, "n", false, true) }
        handler.module.setup(handler.opts)
        state.maps[lhs].callback = vim.fn.maparg(lhs, "n", false, true).callback
        keys[lhs] = true
      end
      state.keyword_after = vim.bo.iskeyword
      -- AstroLSP must not replace these mappings when another client attaches.
      vim.b.html_css_keymaps = keys
    end)
  end

  local group = vim.api.nvim_create_augroup("html-css-buffer-mappings", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = function(args) configure_buffer(args.buf) end,
  })
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = group,
    callback = function(args) attached[args.buf] = nil end,
  })
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    configure_buffer(bufnr)
  end
end

return M
