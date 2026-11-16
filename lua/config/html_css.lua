local M = {}

-- Compatibility for nvim-html-css 3f246f6: inline-only styles are skipped and
-- buffer:// sources are discarded. Preserve them with their HTML positions.
local function update_inline_styles(bufnr)
  local parser = vim.treesitter.get_parser(bufnr, "html")
  if not parser then return end
  local query = vim.treesitter.query.parse("html", "(style_element (raw_text) @css)")
  local data = { class = {}, id = {}, imports = {} }
  for _, tree in ipairs(parser:parse()) do
    for _, node in query:iter_captures(tree:root(), bufnr) do
      local row, col = node:range()
      local css = require("html-css.parsers.css").setup(vim.treesitter.get_node_text(node, bufnr), true)
      for _, kind in ipairs { "class", "id" } do
        for _, item in ipairs(css[kind]) do
          for _, position in pairs(item.range) do
            if position.line == 0 then position.character = position.character + col end
            position.line = position.line + row
          end
          table.insert(data[kind], item)
        end
      end
    end
  end

  local cache = require "html-css.cache"
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local source = "buffer://" .. filename
  cache:update(source, data)
  -- Cache keys remain buffer:// to avoid filesystem watchers; LSP definitions
  -- must point to the actual document, with positions adjusted above.
  for _, kind in ipairs { "class", "id" } do
    for _, item in ipairs(data[kind]) do
      item.source_name = filename
    end
  end
  local sources = vim.tbl_keys((cache._buffers[bufnr] or {})._sources or {})
  table.insert(sources, source)
  cache:link_sources(bufnr, sources)
end

function M.setup(plugin, opts)
  local group = vim.api.nvim_create_augroup("html-css-buffer", { clear = true })
  local patterns = vim.tbl_map(function(ext) return "*." .. ext end, opts.enable_on)
  local cache = require "html-css.cache"
  -- Upstream returns early when the last stylesheet is removed. Clear the old
  -- links first so that this does not leave stale completion items behind.
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePre" }, {
    group = group,
    pattern = patterns,
    callback = function(args) cache:cleanup(args.buf) end,
  })

  local chunk = assert(loadfile(plugin.dir .. "/lua/html-css/init.lua"))
  setfenv(
    chunk,
    setmetatable({
      -- Upstream calls dofile directly; require Neovim's project-file trust.
      dofile = function(path)
        local source = vim.secure.read(path)
        if type(source) == "string" then return assert(loadstring(source, "@" .. path))() end
      end,
    }, { __index = _G })
  )
  local html_css = chunk()
  package.loaded["html-css"] = html_css
  html_css.setup(opts)

  -- FileType replays undo ftplugin options, so reapply CSS word boundaries here.
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = plugin.ft,
    callback = function(args)
      if vim.bo[args.buf].buftype ~= "" then return end
      vim.api.nvim_buf_call(args.buf, function()
        if not vim.tbl_contains(vim.opt_local.iskeyword:get(), "-") then
          vim.opt_local.iskeyword:append "-"
          local undo = vim.b.undo_ftplugin
          vim.b.undo_ftplugin = (undo and undo .. " | " or "") .. "setlocal iskeyword-=-"
        end
      end)
    end,
  })

  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePre" }, {
    group = group,
    pattern = patterns,
    callback = function(args)
      if vim.bo[args.buf].buftype ~= "" or not vim.tbl_contains(plugin.ft, vim.bo[args.buf].filetype) then return end
      update_inline_styles(args.buf)
    end,
  })
end

return M
