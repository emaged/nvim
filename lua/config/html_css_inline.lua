local M = {}

-- Compatibility for nvim-html-css 3f246f6: inline-only styles are skipped and
-- buffer:// sources are discarded. Keep this separate from the normal setup
-- until upstream handles inline sources and their original HTML positions.
function M.update(bufnr)
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

return M
