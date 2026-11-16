local M = {}

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
      require("config.html_css_inline").update(args.buf)
    end,
  })
end

return M
