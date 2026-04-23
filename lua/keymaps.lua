-- =========================
-- Keymaps (run immediately)
-- =========================

-- fix tab on empty line indenting
vim.keymap.set("i", "<Tab>", function()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()

  if vim.o.indentexpr ~= "" and col == 0 and line:match "^%s*$" then
    return vim.api.nvim_replace_termcodes("<C-f>", true, false, true)
  end

  return "\t"
end, { expr = true })

-- Restart neovim
vim.keymap.set({ "v", "n" }, "<localleader>R", "<cmd>restart<CR>", { desc = "Restart Neovim" })

-- source current file
vim.keymap.set("n", "<Leader><Leader>s", "<cmd>source %<cr>", { desc = "source current file" })

-- easy arrow keymap
vim.keymap.set("i", "<C-l>", "<space>=><space>")

-- Search and replace word under the cursor
vim.keymap.set("n", "gre", [[:%s/\<<C-r><C-w>\>//g<Left><Left>]], { desc = "native search and replace" })

-- open current file with alt + b
vim.keymap.set("n", "<A-b>", ":!xdg-open % &<CR><CR>", {
  silent = true,
})

-- Select all with Leader + A
vim.keymap.set("n", "<Leader>a", "ggVG", {
  silent = true,
})

-- Copy buffer content
vim.keymap.set("n", "<Leader>y", ":%y<CR>", {
  silent = true,
})

-- =========================================================
-- <localleader> deletes into black hole register
-- =========================================================
-- Delete c without yank
vim.keymap.set({ "v", "n" }, "<localleader>c", '"_c', {
  silent = true,
})
vim.keymap.set({ "v", "n" }, "<localleader>C", '"_C', {
  silent = true,
})

-- Delete x without yank in normal Mode
vim.keymap.set("n", "<localleader>x", '"_x', {
  silent = true,
})
-- Delete x without yank in Visual Mode
vim.keymap.set("v", "<localleader>x", '"_d', {
  silent = true,
})
-- Delete X without yank in normal Mode
vim.keymap.set("n", "<localleader>X", '"_X', {
  silent = true,
})

-- Alternative delete
vim.keymap.set({ "v", "n" }, "<localleader>d", '"_d', {
  silent = true,
})

vim.keymap.set({ "v", "n" }, "<localleader>D", '"_D', {
  silent = true,
})

-- =========================================================
-- Regular copy/paste keymaps with C-v and C-c
-- =========================================================
-- -- Make Ctrl+q Visual Visual Block Mode
vim.keymap.set({ "v", "n" }, "<C-q>", "<C-v>", {
  silent = true,
  desc = "Visual Block Mode",
})

-- Visual mode: copy selection to system clipboard
vim.keymap.set("i", "<C-v>", "<C-o>p", {
  silent = true,
  desc = "regular paste",
})
vim.keymap.set("n", "<C-v>", "p", {
  silent = true,
  desc = "regular paste",
})
vim.keymap.set("v", "<C-v>", "P", {
  silent = true,
  desc = "regular paste",
})

-- Visual mode: copy selection to system clipboard
vim.keymap.set({ "v", "n" }, "<C-c>", "y", {
  silent = true,
  desc = "Copy selection to clipboard",
})

-- =========================================================
-- Universal <Esc> (dismiss everything, then send real <Esc>)
-- =========================================================
vim.keymap.set("n", "<Esc>", function()
  -- Dismiss Noice if present
  pcall(vim.cmd, "NoiceDismiss")

  -- Clear substitute.nvim range highlights if present
  vim.cmd "silent! lua require('substitute.range').clear_match()"

  -- You can stack more later:
  -- pcall(vim.cmd, "noh")
  -- pcall(require("flash").dismiss)

  return "<Esc>"
end, { expr = true, silent = true, desc = "Universal dismiss" })

-- New line with enter/ shift enter in normal mode
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    if vim.bo.buftype == "" then
      vim.keymap.set("n", "<CR>", "o<Esc>", { buffer = true, silent = true })
      vim.keymap.set("n", "<S-CR>", "O<Esc>j", { buffer = true, silent = true })
    end
  end,
})

-- ctrl + z for insert mode undo
vim.keymap.set("i", "<C-z>", "<C-o>u")
vim.keymap.set("i", "<C-s-z>", "<C-o><C-r>")

-- =========================================================
-- Primeagen keymaps
-- =========================================================
vim.keymap.set("n", "<C-d>", "<C-d>zz", {
  silent = true,
  desc = "Center on down",
})

vim.keymap.set("n", "<C-u>", "<C-u>zz", {
  silent = true,
  desc = "Center on up",
})

-- tmux sessionizer keymaps --
-- ------------------------ --
vim.keymap.set("n", "<M-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
--long running sessions
-- vim.keymap.set("n", "<M-l>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")
-- vim.keymap.set("n", "<M-o>", "<cmd>silent !tmux neww tmux-sessionizer -s 1<CR>")
-- vim.keymap.set("n", "<M-p>", "<cmd>silent !tmux neww tmux-sessionizer -s 2<CR>")
-- vim.keymap.set("n", "<M-r>", "<cmd>silent !tmux neww tmux-sessionizer -s 3<CR>")

-- old or work in progress keymaps
-- TODO: fix this keymap somehow
-- search backwards with ,,
-- vim.keymap.set({ "o", "v", "n" }, "<localleader>,", ",", { desc = "backwards search" })

-- =========================================================
-- Undo Keymaps
-- =========================================================
-- main
-- vim.keymap.set("i", ",", ",<C-g>u")
-- vim.keymap.set("i", ".", ".<C-g>u")
-- vim.keymap.set("i", "!", "!<C-g>u")
-- vim.keymap.set("i", "?", "?<C-g>u")
-- vim.keymap.set("i", ";", ";<C-g>u")
-- vim.keymap.set("i", ":", ":<C-g>u")
-- vim.keymap.set("i", " ", " <C-g>u")
-- vim.keymap.set("i", "<cr>", "<cr><C-g>u")
-- vim.keymap.set("i", "<C-u>", "<C-u><C-g>u")
-- vim.keymap.set("i", "<C-w>", "<C-w><C-g>u")
-- vim.keymap.
--
-- -- optional
-- vim.keymap.set("i", "[", "[<C-g>u")
-- vim.keymap.set("i", "{", "{<C-g>u")
-- vim.keymap.set("i", "=", "=<C-g>u")
-- vim.keymap.set("i", "/", "/<C-g>u")
-- vim.keymap.set("i", "\\", "\\<C-g>u")

-- Delete s without yank in normal Mode
-- vim.keymap.set("n", "<localleader>s", '"_s', {
--   silent = true,
-- })
-- -- Delete s without yank in Visual Mode
-- vim.keymap.set("v", "<localleader>s", '"_c', {
--   silent = true,
-- })
-- -- Delete S without yank
-- vim.keymap.set({ "v", "n" }, "<localleader>S", '"_S', {
--   silent = true,
-- })
