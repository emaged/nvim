return {
  "rebelot/heirline.nvim",
  opts = function(_, opts)
    local status = require "astroui.status"
    opts.statusline = { -- statusline
      hl = { fg = "fg", bg = "bg" },
      status.component.mode {
        mode_text = { padding = { left = 1, right = 1 } },
      }, -- add the mode text
      status.component.git_branch(),
      status.component.file_info {
        filename = {},
        filetype = false,
        -- file_icon = false,
        -- file_modified = false,
        -- file_read_only = false,
      },
      status.component.git_diff(),
      status.component.fill(),
      status.component.cmd_info(),
      status.component.fill(),
      status.component.diagnostics(),
      status.component.lsp(),
      status.component.virtual_env(),
      status.component.treesitter(),
      status.component.file_info {
        filename = false,
        -- file_icon = false,
        file_modified = false,
        file_read_only = false,
        filetype = {},
        surround = { separator = "right" },
      },
      status.component.nav(),
      -- remove the 2nd mode indicator on the right
    }
  end,
}
