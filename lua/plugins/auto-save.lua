-- some recommended exclusions. you can use `:lua print(vim.bo.filetype)` to
-- get the filetype string of the current buffer
local excluded_filetypes = {
  -- this one is especially useful if you use neovim as a commit message editor
  "gitcommit",
  -- most of these are usually set to non-modifiable, which prevents autosaving
  -- by default, but it doesn't hurt to be extra safe.
  "NvimTree",
  "Outline",
  "TelescopePrompt",
  "alpha",
  "dashboard",
  "lazygit",
  "neo-tree",
  "oil",
  "prompt",
  "toggleterm",
}

local excluded_filenames = {
  "do-not-autosave-me.lua",
}

-- roots to enable autosave for automatically
local roots = {
  vim.fs.normalize "~/Dropbox/projects",
  vim.fs.normalize "~/Dropbox/Vault",
  vim.fs.normalize "~/nextcloud",
}

local function save_condition(buf)
  buf = buf or vim.api.nvim_get_current_buf()

  -- 1. filetype / filename / special buffers
  if
    vim.tbl_contains(excluded_filetypes, vim.bo[buf].filetype)
    or vim.tbl_contains(excluded_filenames, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t"))
  then
    return false
  end

  if vim.bo[buf].buftype ~= "" then return false end

  -- 2. file path
  local filepath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":p")
  if filepath == "" then return false end
  filepath = vim.fs.normalize(filepath)

  -- 3. inside allowed roots
  for _, root in ipairs(roots) do
    local rel = vim.fs.relpath(root, filepath)
    -- also check for ../ matches
    if rel and not rel:match "^%.%." then return true end
  end

  return false
end

return {
  "okuuva/auto-save.nvim",
  event = { "User AstroFile", "InsertEnter" },
  dependencies = {
    "AstroNvim/astrocore",
    opts = {
      autocmds = {
        autoformat_toggle = {
          -- Disable autoformat before saving
          {
            event = "User",
            desc = "Disable autoformat before saving",
            pattern = "AutoSaveWritePre",
            callback = function()
              -- Save global autoformat status
              vim.g.OLD_AUTOFORMAT = vim.g.autoformat
              vim.g.autoformat = false

              local old_autoformat_buffers = {}
              -- Disable all manually enabled buffers
              for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
                if vim.b[bufnr].autoformat then
                  table.insert(old_autoformat_buffers, bufnr)
                  vim.b[bufnr].autoformat = false
                end
              end

              vim.g.OLD_AUTOFORMAT_BUFFERS = old_autoformat_buffers
            end,
          },
          -- Re-enable autoformat after saving
          {
            event = "User",
            desc = "Re-enable autoformat after saving",
            pattern = "AutoSaveWritePost",
            callback = function()
              -- Restore global autoformat status
              vim.g.autoformat = vim.g.OLD_AUTOFORMAT
              -- Re-enable all manually enabled buffers
              for _, bufnr in ipairs(vim.g.OLD_AUTOFORMAT_BUFFERS or {}) do
                vim.b[bufnr].autoformat = true
              end
            end,
          },
        },
      },
    },
  },

  keys = {
    { "<Leader>W", "<cmd>ASToggle<CR>", desc = "Toggle auto-save" },
  },
  opts = {
    condition = save_condition,
  },

  config = function(_, opts)
    -- set up the plugin with its opts
    require("auto-save").setup(opts)

    -- your custom autocmds
    local group = vim.api.nvim_create_augroup("autosave", {})

    vim.api.nvim_create_autocmd("User", {
      pattern = "AutoSaveEnable",
      group = group,
      callback = function() vim.notify("AutoSave enabled", vim.log.levels.INFO) end,
    })

    vim.api.nvim_create_autocmd("User", {
      pattern = "AutoSaveDisable",
      group = group,
      callback = function() vim.notify("AutoSave disabled", vim.log.levels.INFO) end,
    })
  end,
}
