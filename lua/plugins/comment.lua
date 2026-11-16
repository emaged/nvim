-- if true then return {} end -- WARN: REMOVE THIS LINE TO ACTIVATE THIS FILE
return {
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    enabled = true,
    init = function() vim.g.skip_ts_context_commentstring_module = true end,
    opts = {
      enable_autocmd = false,
    },
  },
  {
    "numToStr/Comment.nvim",
    enabled = true,
    opts = function(_, opts)
      local commentstring_avail, commentstring = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
      if commentstring_avail then opts.pre_hook = commentstring.create_pre_hook() end
    end,
  },

  -- {
  --   "echasnovski/mini.comment",
  --   event = "VeryLazy",
  --   opts = {
  --     options = {
  --       custom_commentstring = function()
  --         return require("ts_context_commentstring.internal").calculate_commentstring() or vim.bo.commentstring
  --       end,
  --     },
  --   },
}
