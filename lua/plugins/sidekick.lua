return {
  "folke/sidekick.nvim",
  opts = {
    nes = { enabled = true },
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
      win = {
        keys = {
          shift_cr = {
            "<S-CR>",
            function(self)
              if self:is_running() then vim.api.nvim_chan_send(self.job, "\x1b[13;2u") end
            end,
            mode = "t",
            desc = "CSI-u Shift+Enter",
          },
          alt_cr = {
            "<A-CR>",
            function(self)
              if self:is_running() then vim.api.nvim_chan_send(self.job, "\x1b[13;3u") end
            end,
            mode = "t",
            desc = "CSI-u Alt+Enter",
          },
        },
      },
      tools = {
        codex = { cmd = { "codex" } },
      },
    },
  },
}
